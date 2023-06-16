#! /bin/bash
#
# USAGE
# =====
#     nmaper [-a MIN-RATE] [-h] [-s] [-r] [-t] [-u] [-x] [-o OUTPUT_FOLDER] 
#         -i target_ip
# 
# DESCRIPTION
# ===========
# Wrapper script around NMAP.
# 
# With only the mandatory '-i' option, the script will perform the below 
# actions sequentially:
# 
# - Fast TCP scan (100 most common TCP ports)
# - Regulard TCP scan (1000 most common TCP ports)
# - Thorough TCP scan (all 65535 TCP/ports)
# - Fast UDP port scan (100 most common UDP ports)
# - Service fingerprinting and run some NSE scripts
# 
# It is however possible to launch a predefine scan. See the options.
# 
# OPTIONS
# =======
#     -a <min_rate>       nmap --min-rate option (Packets per second). On 
# HackTHeBox or other CTF, you can go very high (e.g. 5000+) without risking
# crashing most services. (Default: 200)
#     -h                  Print this help
#     -i <target_ip>      Target IP
#     -o <output_folder>  Output folder name
#     -r                  Launch a regular TCP scan (top 1000 common ports)
#     -s                  Launch a short TCP scan (top 100 common ports)
#     -t                  Launch a thorough TCP scan (all 65535 ports)
#     -u                  Launch a short UDP scan (top 100 ports)
#     -x                  Skip service fingerprinting and NSE scripts
# 
# AUTHOR
# =======
# @0nemask - 2022


# ENABLE DEBUG
# set -euxo pipefail

RED='\e[91m'
GREEN='\e[92m'
BLUE='\e[94m'
BOLD='\e[1m'
NC='\e[0m'

OPT_HELP='false'
OPT_SHORT='false'
OPT_REGULAR='false'
OPT_THOROUGH='false'
OPT_SHORT_UDP='false'
OPT_SKIP='false'

IS_ROOT='false'
HAS_HOSTNAME='false'
OPEN_PORTS='false'

MINRATE=200

while getopts ':a:hi:o:rstux' flag
do
    case "${flag}" in
        'a')
            MINRATE=${OPTARG}
            ;;
        'h')
            OPT_HELP='true'
            ;;
        'i')
            IP=${OPTARG}
            ;;
        'o')
            OUTPUT_FOLDER=${OPTARG}
            ;;
        'r')
            OPT_REGULAR='true'
            ;;
        's')
            OPT_SHORT='true'
            ;;
        't')
            OPT_THOROUGH='true'
            ;;
        'u')
            OPT_SHORT_UDP='true'
            ;;
        'x')
            OPT_SKIP='true'
            ;;
        '?')
            echo "nmaper: invalid option -- '${OPTARG}'" >&2
            echo "Try 'nmaper -h' for more information"
            exit 1
            ;;
        *)
            echo "nmaper: unimplemented option -- '${flag}'" >&2
            echo "Try 'nmaper -h' for more information"
            exit 1
            ;;
    esac
done

function help(){
    echo """USAGE
=====
    nmaper [-a MIN-RATE] [-h] [-s] [-r] [-t] [-u] [-x] [-o OUTPUT_FOLDER] 
        -i target_ip

DESCRIPTION
===========
Wrapper script around NMAP.

With only the mandatory '-i' option, the script will perform the below 
actions sequentially:

- Fast TCP scan (100 most common TCP ports)
- Regulard TCP scan (1000 most common TCP ports)
- Thorough TCP scan (all 65535 TCP/ports)
- Fast UDP port scan (100 most common UDP ports)
- Service fingerprinting and run some NSE scripts

It is however possible to launch a predefine scan. See the options.

OPTIONS
=======
    -a <min_rate>       nmap --min-rate option (Packets per second). On 
HackTHeBox or other CTF, you can go very high (e.g. 5000+) without risking
crashing most services. (Default: 200)
    -h                  Print this help
    -i <target_ip>      Target IP
    -o <output_folder>  Output folder name
    -r                  Launch a regular TCP scan (top 1000 common ports)
    -s                  Launch a short TCP scan (top 100 common ports)
    -t                  Launch a thorough TCP scan (all 65535 ports)
    -u                  Launch a short UDP scan (top 100 ports)
    -x                  Skip service fingerprinting and NSE scripts

AUTHOR
=======
@0nemask - 2022

"""

    exit 0
}

function print_err(){
    echo -e "${BOLD}${RED}$1${NC}"
}

function print_succ(){
    echo -e "${BOLD}${GREEN}$1${NC}"
}

function print_info(){
    echo -e "${BOLD}${BLUE}$1${NC}"
}

function is_root(){
    if [ "$EUID" -ne 0 ];then
        echo "[!] This program must be run as root (some scans require 'sudo' \
privileges)."
        exit 1
    else
        IS_ROOT='true'
    fi
}

function init(){
    START=$(date +%s)
    if [ -z ${OUTPUT_FOLDER+x} ] ; then
        export OUTPUT_FOLDER="nmaper-$IP"
        # Check if output directory already exists
        if [ ! -d "$OUTPUT_FOLDER" ]; then
            mkdir -p "$OUTPUT_FOLDER/nmap"
        fi
    else
        if [ ! -d "$OUTPUT_FOLDER" ]; then
            mkdir -p "$OUTPUT_FOLDER/nmap"
        fi
    fi
    export NMAP_FOLDER="$OUTPUT_FOLDER/nmap"
    export LOGFILE="$OUTPUT_FOLDER/00-nmaper-$IP.log"
    export SHORT_SCAN_PORTS_TMPFILE="$OUTPUT_FOLDER/.tmp-$IP-open-ports-short"
    export REGULAR_SCAN_PORTS_TMPFILE="$OUTPUT_FOLDER/.tmp-$IP-open-ports-regular"
    export FULL_SCAN_PORTS_TMPFILE="$OUTPUT_FOLDER/.tmp-$IP-open-ports-full"
    export UDP_SHORT_SCAN_PORTS_TMPFILE="$OUTPUT_FOLDER/.tmp-$IP-open-ports-short-udp"
}

function end(){
    echo -e "\n[*] Cleaning up" | tee -a  "$LOGFILE"
    if ${IS_ROOT};then
        sudo rm "$OUTPUT_FOLDER"/.tmp-* 1>&2 2>/dev/null
    else
        rm "$OUTPUT_FOLDER"/.tmp-* 1>&2 2>/dev/null
    fi

    END=$(date +%s)
    echo -e "\n----------| SCAN FINISHED in $(("$END"-"$START")) seconds |----------" | \
        tee -a  "$LOGFILE"
    unset "$LOGFILE"
    unset "$SHORT_SCAN_PORTS_TMPFILE"
    unset "$REGULAR_SCAN_PORTS_TMPFILE"
    unset "$FULL_SCAN_PORTS_TMPFILE"
    unset "$UDP_SHORT_SCAN_PORTS_TMPFILE"
    unset "$OUTPUT_FOLDER"
    exit 0
}

function short_tcp_scan(){
    echo "[*] Starting quick TCP scan" | tee -a "$LOGFILE"
    
    nmap -Pn -v --open -T4 -sT -F "$IP" -oA "$NMAP_FOLDER/nmap-$IP-short-tcp" | \
        grep "Discovered" | cut -d" " -f 4 | cut -d"/" -f1 \
        > "$SHORT_SCAN_PORTS_TMPFILE"
    
    lst_ports=$(cat "$SHORT_SCAN_PORTS_TMPFILE" | cut -d " " -f 4 | \
        cut -d"/" -f1 | sort -n | tr '\n' ',' | sed 's/,$//')
    
    open_tcp_ports
    if ${OPEN_PORTS}; then 
        echo -ne "[+] Ports found: " | tee -a "$LOGFILE"
        print_succ "$lst_ports" | tee -a "$LOGFILE"
        if ! ${HAS_HOSTNAME} ; then
            get_hostname
        fi
    fi
}

function regular_tcp_scan(){
    echo "[*] Starting default TCP scan" | tee -a "$LOGFILE"

    nmap -Pn -v --open -sT "$IP" --min-rate "$MINRATE" --max-retries 1 -oA \
        "$NMAP_FOLDER/nmap-$IP-regular-tcp" | grep "Discovered" | cut -d" " -f 4 | \
        cut -d"/" -f1 > "$REGULAR_SCAN_PORTS_TMPFILE"
    
    lst2_ports=$(cat "$REGULAR_SCAN_PORTS_TMPFILE" | cut -d " " -f 4 | \
        cut -d"/" -f1 | sort -n | tr '\n' ',' | sed 's/,$//')

    open_tcp_ports

    if ${OPEN_PORTS}; then 
        if ${OPT_REGULAR} ; then
            echo -en "[+] Ports found: " | tee -a "$LOGFILE"
            print_succ "$lst2_ports"  | tee -a "$LOGFILE"
        else
        if [ "$lst_ports" != "$lst2_ports" ]; then
                echo -en "[+] New Ports found: " | tee -a "$LOGFILE"
                print_succ "$lst2_ports"  | tee -a "$LOGFILE"
            fi
        fi
    fi

    if ! ${HAS_HOSTNAME} ; then
        get_hostname
    fi
}

function full_tcp_scan(){
    echo "[*] Starting full TCP scan" | tee -a "$LOGFILE"
    
    nmap -Pn -v --open -T4 -sT -p- "$IP" --max-retries 1 --max-rate "$MINRATE" -oA \
        "$NMAP_FOLDER/nmap-$IP-full-tcp" | grep "Discovered" | cut -d" " -f 4 | \
        cut -d"/" -f1 > "$FULL_SCAN_PORTS_TMPFILE"
    
    lst3_ports=$(cat "$FULL_SCAN_PORTS_TMPFILE" | cut -d " " -f 4 | \
        cut -d"/" -f1 | sort -n | tr '\n' ',' | sed 's/,$//')

    open_tcp_ports

    if ${OPEN_PORTS}; then
        if ${OPT_THOROUGH} ; then
            echo -en "[+] Ports found: " | tee -a "$LOGFILE"
            print_succ "$lst3_ports"  | tee -a "$LOGFILE"
        else
            if [ "$lst_ports" !=  "$lst3_ports" ]; then
                echo -en "[+] Ports found: " | tee -a "$LOGFILE"
                print_succ "$lst3_ports" | tee -a "$LOGFILE"
            fi
        fi
    fi
    
    if ! ${HAS_HOSTNAME} ; then
        get_hostname
    fi
}

function udp_short_scan(){
    echo "[*] Starting short UDP scan" | tee -a "$LOGFILE"

    nmap -Pn -v --open -T4 -sU "$IP" --max-retries 1 --min-rate $MINRATE -oA \
        "$NMAP_FOLDER/nmap-$IP-short-udp" | grep "Discovered" | cut -d" " -f 4 | \
        cut -d"/" -f1 > "$UDP_SHORT_SCAN_PORTS_TMPFILE"

    if [ -s "$UDP_SHORT_SCAN_PORTS_TMPFILE" ]; then
        lst4_ports=$(cat "$UDP_SHORT_SCAN_PORTS_TMPFILE" | cut -d " " -f 4 | \
        cut -d"/" -f1 | sort -n | tr '\n' ',' | sed 's/,$//')
        echo -e "[+] UDP Ports found: " | tee -a "$LOGFILE"
        print_succ "$lst4_ports" | tee -a "$LOGFILE"
    fi
}

function open_tcp_ports(){
    if [ -s $SHORT_SCAN_PORTS_TMPFILE ] || \
        [ -s $REGULAR_SCAN_PORTS_TMPFILE ] || \
        [ -s $FULL_SCAN_PORTS_TMPFILE ]; then
        OPEN_PORTS='true'
    else
        OPEN_PORTS='false'
    fi
}

function version(){
    if ${OPT_SKIP}; then
        return
    fi
    open_tcp_ports

    if ! ${OPEN_PORTS}; then
        print_err "[-] No open ports found, exiting" | tee -a "$LOGFILE"
        end
    fi

    PORTS=$(cat "$1" | tr '\n' ',' | sed 's/.$//g')

    echo "" >> "$LOGFILE"

    echo "[*] Starting service fingerprinting" | tee -a "$LOGFILE"

    print_info "$(nmap -Pn -sT -sV "$IP" -p "$PORTS" | tail -n +4 | \
        head -n -2)" | tee -a "$LOGFILE"
}

function run_nmap_script(){
    if ${OPT_SKIP}; then
        return
    fi
    PORTS=$(cat "$1" | tr '\n' ',' | sed 's/.$//g')

    echo "" | tee -a "$LOGFILE"
    echo "[*] Running NSE 'default', 'vuln' and 'safe' scripts" | \
        tee -a "$LOGFILE"
    
    print_info "$(nmap -Pn -sT -sC -sV --script-timeout 20 \
        --script="vuln and safe" -T4 -p "$PORTS" "$IP" | tail -n +4 | \
        head -n -2)" | tee -a "$LOGFILE"

}

function get_hostname(){
    PORT="443"
    SSL_FOLDER=$OUTPUT_FOLDER/ssl

    if grep "$PORT" "$OUTPUT_FOLDER"/.tmp* 1>/dev/null 2>&1 ; then
        if [ ! -d "$SSL_FOLDER" ] ; then
            mkdir "$SSL_FOLDER"
        fi
        CERT_FILE="$SSL_FOLDER"/"$IP"_"$PORT".crt
        echo | openssl s_client -connect "$IP:$PORT" 2>/dev/null | \
            openssl x509 -noout -text > "$CERT_FILE"
        echo -en "[*] SSL Certificate from port ${BOLD}${BLUE}$PORT/tcp${NC} " | \
            tee -a "$LOGFILE"
        echo -e "saved to ${BOLD}${BLUE}$CERT_FILE${NC}" | tee -a "$LOGFILE"
        
        DOMAIN=$(cat "$CERT_FILE" | grep -Po 'CN = \K(.*),' | sort -u | \
            sed 's/.$//g')
        MAIN_DOMAIN=$(echo "$DOMAIN" | rev | cut -d "." -f 1,2 | rev )

        echo -e "[+] Domain Name found from SSL certificate: \
${BOLD}${GREEN}$MAIN_DOMAIN${NC}, ${BOLD}${GREEN}$DOMAIN${NC}" | tee -a  "$LOGFILE"

        HAS_HOSTNAME='true'
    else
        return
    fi 
}

function main(){

    # Print help function
    if ${OPT_HELP}; then
        help
        exit 0
    fi

    init

    # Exit if no argument is passed to the -i option
    if [ -z ${IP+x} ]; then
        echo "The target (-i) option is mandatory (e.g. -i 10.10.10.14)"
        exit 1
    fi

    echo -e "----------| SCAN START |----------\n" | tee -a "$LOGFILE"
    echo -en "[*] Target => " | tee -a "$LOGFILE"
    print_info "$IP" | tee -a "$LOGFILE"
    echo -en "[*] Output Folder => " | tee -a "$LOGFILE"
    print_info "$OUTPUT_FOLDER" | tee -a "$LOGFILE"
    echo -en "[*] Min Rate => " | tee -a "$LOGFILE"
    print_info "$MINRATE" | tee -a "$LOGFILE"
    echo "" | tee -a "$LOGFILE"

    # Run a short TCP scan with service fingerprinting and NSE scripts
    if ${OPT_SHORT}; then
        short_tcp_scan
        version "$SHORT_SCAN_PORTS_TMPFILE"
        run_nmap_script "$SHORT_SCAN_PORTS_TMPFILE"
        end
    fi

    # Run a regular (top 1000 TCP ports) scan with service fingerprinting and 
    # NSE scripts
    if ${OPT_REGULAR}; then
        regular_tcp_scan
        version "$REGULAR_SCAN_PORTS_TMPFILE"
        run_nmap_script "$REGULAR_SCAN_PORTS_TMPFILE"
        end
    fi

    # Run a thorough (65535 TCP ports) scan with service fingerprinting and 
    # NSE scripts
    if ${OPT_THOROUGH}; then
        full_tcp_scan
        version "$FULL_SCAN_PORTS_TMPFILE"
        run_nmap_script "$FULL_SCAN_PORTS_TMPFILE"
        end
    fi

    # Only run a short UDP scan (top 100 ports) with service fingerprinting and
    # NSE scripts
    if ${OPT_SHORT_UDP}; then
        # Check if we have sudo permissions
        is_root
        udp_short_scan
        version "$UDP_SHORT_SCAN_PORTS_TMPFILE"
        run_nmap_script "$UDP_SHORT_SCAN_PORTS_TMPFILE"
        end
    fi

    # Check if we have sudo permissions
    is_root

    # If only the -i option is specified, then run all scans sequentially
    short_tcp_scan
    regular_tcp_scan
    full_tcp_scan

    if [ -s $SHORT_SCAN_PORTS_TMPFILE ] || \
        [ -s $REGULAR_SCAN_PORTS_TMPFILE ] || \
        [ -s $FULL_SCAN_PORTS_TMPFILE ] ; then
        if [ $(stat -c%s "$SHORT_SCAN_PORTS_TMPFILE") == $(stat -c%s \
            "$REGULAR_SCAN_PORTS_TMPFILE") ]|| \
            [ $(stat -c%s "$SHORT_SCAN_PORTS_TMPFILE") == $(stat -c%s \
            "$FULL_SCAN_PORTS_TMPFILE") ]|| \
            [ $(stat -c%s "$REGULAR_SCAN_PORTS_TMPFILE") == $(stat -c%s \
            "$FULL_SCAN_PORTS_TMPFILE") ]; then
            echo "[-] No new TCP ports found"
        else
            echo -n "[+] Final TCP ports found : " | tee -a "$LOGFILE"
            print_succ "$lst3_ports" | tee -a "$LOGFILE"
        fi
    fi

    udp_short_scan
    # If UDP ports are found
    if [ -s "$UDP_SHORT_SCAN_PORTS_TMPFILE" ] ; then
        echo "[+] UDP ports found : $lst4_ports" | tee -a "$LOGFILE"
    else
        echo "[-] No UDP ports open (from top most 100 commons)"
    fi

    version "$FULL_SCAN_PORTS_TMPFILE"
    run_nmap_script "$FULL_SCAN_PORTS_TMPFILE"

    end
}

main