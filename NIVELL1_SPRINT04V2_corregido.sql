CREATE TABLE companies (
company_id VARCHAR(15),
company_name VARCHAR(100),
phone VARCHAR(15),
email VARCHAR(100),
country VARCHAR(100),
website VARCHAR(100),
PRIMARY KEY (company_id) ); 

CREATE TABLE credit_cards (
id VARCHAR(15),
user_id VARCHAR(15),
iban VARCHAR(30),
pan VARCHAR(20),
pin VARCHAR(4),
cvv INT,
track1 VARCHAR(100),
track2 VARCHAR(100),
expiring_date DATE,
PRIMARY KEY (id) );

DROP TABLE products ;

CREATE TABLE products (
id VARCHAR(50),
product_name VARCHAR(50),
price DECIMAL(10,2),
colour VARCHAR(50),
weight VARCHAR(50),
warehouse_id VARCHAR(50),
PRIMARY KEY (id) );
#La tabla product la he creado haciendo una nueva tabla , por que no me dejaba introducirla. 

CREATE TABLE transactions (
id VARCHAR(50),
card_id VARCHAR(15),
bussines_id VARCHAR(15),
fecha_hora timestamp,
amount DECIMAL (10,2),
declined BOOLEAN, 
products_ids VARCHAR(20),
user_id INT,
latitude VARCHAR(20),
longitude VARCHAR(20),
PRIMARY KEY (id) );

CREATE TABLE users ( 
id VARCHAR (4),
name VARCHAR (50),
surname VARCHAR (50),
phone VARCHAR(50),
email VARCHAR(50),
birth_date DATE,
country VARCHAR(50),
city VARCHAR(50),
postal_code VARCHAR(10),
address VARCHAR(50),
PRIMARY KEY (id) );
#Tabla users por el problema de las comillas, la he creado haciendo una nueva.

LOAD DATA LOCAL INFILE "C:\Users\usuario\Documents\FADD\FADD CURS PRESENCIAL\datos sprint 03\users_ca.csv"
INTO TABLE users
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\r\n"
IGNORE 1 ROWS;
#codigo para entrar documento csv, pero me da error: "file request rejected due to restrictions on access", por lo tanto he subido los documentos con wizard.

DROP TABLE users_all;

CREATE TABLE users_all AS
SELECT id, name, surname, phone, email, birth_date, country, city, postal_code, address FROM users_ca
UNION ALL
SELECT id, name, surname, phone, email, birth_date, country, city, postal_code, address FROM users_uk 
UNION ALL 
SELECT id, name, surname, phone, email, birth_date, country, city, postal_code, address FROM users_usa
ORDER BY id desc ; 



SELECT
 SUBSTRING_INDEX(products_ids, ",", 1) AS product1,
 SUBSTRING_INDEX(products_ids, ",", 2) AS product2,
 SUBSTRING_INDEX(products_ids, ",", 3) AS product3,
 SUBSTRING_INDEX(products_ids, ",", 4) AS product4
FROM transactions;

SELECT
 SUBSTRING_INDEX(SUBSTRING_INDEX(products_ids, ",", 1), ",", -1) AS product1,
 SUBSTRING_INDEX(SUBSTRING_INDEX(products_ids, ",", 2), ",", -1) AS product2,
 SUBSTRING_INDEX(SUBSTRING_INDEX(products_ids, ",", 3), ",", -1) AS product3,
 SUBSTRING_INDEX(SUBSTRING_INDEX(products_ids, ",", 4), ",", -1) AS product4
FROM transactions;

SELECT
id,
card_id,
bussines_id,
fecha_hora,
amount,
declined,
user_id,
latitude,
longitude,

  SUBSTRING_INDEX(products_ids, ",", 1) AS product1,
  
  CASE WHEN LENGTH(products_ids) - LENGTH(REPLACE(products_ids, ',', '')) >= 1
       THEN SUBSTRING_INDEX(SUBSTRING_INDEX(products_ids, ",", 2), ",", -1) END AS product2,
       
  CASE WHEN LENGTH(products_ids) - LENGTH(REPLACE(products_ids, ',', '')) >= 2
       THEN SUBSTRING_INDEX(SUBSTRING_INDEX(products_ids, ",", 3), ",", -1) END AS product3,
       
  CASE WHEN LENGTH(products_ids) - LENGTH(REPLACE(products_ids, ',', '')) >= 3
       THEN SUBSTRING_INDEX(SUBSTRING_INDEX(products_ids, ",", 4), ",", -1) END AS product4
       
FROM transactions;

#para contar items en un campo separados entre "," : LENGTH(CampoTBL) - LENGTH(REPLACE(CampoTBL, ',', '')) + 1
#para separar los registros d'un campo, en diferentes columnas: SUBSTRING_INDEX(SUBSTRING_INDEX(products_ids, ",", 4), ",", -1)

CREATE TABLE transactions2 AS
SELECT
id,
card_id,
bussines_id,
fecha_hora,
amount,
declined,
user_id,
latitude,
longitude,

  SUBSTRING_INDEX(products_ids, ",", 1) AS product1,
  
  CASE WHEN LENGTH(products_ids) - LENGTH(REPLACE(products_ids, ',', '')) >= 1
       THEN SUBSTRING_INDEX(SUBSTRING_INDEX(products_ids, ",", 2), ",", -1) END AS product2,
       
  CASE WHEN LENGTH(products_ids) - LENGTH(REPLACE(products_ids, ',', '')) >= 2
       THEN SUBSTRING_INDEX(SUBSTRING_INDEX(products_ids, ",", 3), ",", -1) END AS product3,
       
  CASE WHEN LENGTH(products_ids) - LENGTH(REPLACE(products_ids, ',', '')) >= 3
       THEN SUBSTRING_INDEX(SUBSTRING_INDEX(products_ids, ",", 4), ",", -1) END AS product4
       
FROM transactions;



SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE transactions2
ADD foreign key (bussines_id) REFERENCES companies(company_id);

ALTER TABLE transactions2
ADD foreign key (card_id) REFERENCES credit_cards2(id);

ALTER TABLE transactions2
ADD foreign key (user_id) REFERENCES users_all(id);


ALTER TABLE transactions2
ADD FOREIGN KEY (product1) REFERENCES products(id),
ADD FOREIGN KEY (product2) REFERENCES products(id),
ADD FOREIGN KEY (product3) REFERENCES products(id),
ADD FOREIGN KEY (product3) REFERENCES products(id);

#he tenido que revisar que el tipo de dato de product1 y products id fueran los dos INT para poder crear FK.

#EX1.Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.

SELECT *
FROM users_all
JOIN (
 SELECT user_id, count(user_id) as transaction_count
 FROM transactions2
 GROUP BY user_id) subq1
ON users_all.id = subq1.user_id
WHERE  subq1.transaction_count > 30;

#Ex.2.Mostra la mitjana de la suma de transaccions per IBAN de les targetes de crèdit en la companyia Donec Ltd. utilitzant almenys 2 taules.


 SELECT avg(sumaAmountTransaccions) As AverageSumaTransaccions
 FROM ( 
  SELECT SUM(amount) AS sumaAmountTransaccions, iban
  FROM transactions2
  JOIN credit_cards2 ON transactions2.card_id = credit_cards2.id
   WHERE transactions2.bussines_id = (
   SELECT company_id
   FROM companies
   WHERE company_name= "Donec Ltd") 
 GROUP BY iban ) AS Subq1;
 
 ## corrección sin que sea la suma, si no la media:
 
  SELECT avg(AmountTransaccions) As AverageTransaccions
 FROM ( 
  SELECT amount AS AmountTransaccions, iban
  FROM transactions2
  JOIN credit_cards2 ON transactions2.card_id = credit_cards2.id
   WHERE transactions2.bussines_id = (
   SELECT company_id
   FROM companies
   WHERE company_name= "Donec Ltd") ) AS Subq1;
   
   SELECT avg(amount),iban
   FROM transactions2
   JOIN credit_cards2 ON transactions2.card_id = credit_cards2.id
   JOIN companies ON companies.company_id = transactions2.bussines_id
   WHERE company_name= "Donec Ltd" 
   GROUP BY iban;
 



