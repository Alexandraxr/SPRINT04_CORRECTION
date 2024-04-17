#NIVELL 02
#SPRINT 04
#EX1.Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions van ser declinades i genera la següent consulta:
#Quantes targetes estan actives?


CREATE TABLE status_CC
SELECT count(card_id) AS NumCC, card_status
FROM (
SELECT card_id, 
    CASE 
        WHEN  SUM(declined)  >= 3 THEN 'credit card not working'
        ELSE 'credit card working'
    END AS card_status
    FROM transactions2
GROUP BY card_id
) Subq1 
group by Subq1.card_status;

select*
from status_cc;

CREATE TABLE status_CC2
SELECT card_id, card_status
FROM (
SELECT card_id, 
    CASE 
        WHEN  SUM(declined)  >= 3 THEN 'credit card not working'
        ELSE 'credit card working'
    END AS card_status
    FROM transactions2
GROUP BY card_id
) Subq1 ;

SELECT count(card_id), card_status
FROM status_CC2
GROUP BY card_status;


##NO FUNCIONA!! Error Code: 1235. This version of MySQL doesn't yet support 'LIMIT & IN/ALL/ANY/SOME subquery', ejemplos:

SELECT*
FROM transactions2
WHERE card_id IN (
SELECT card_id
FROM transactions2
ORDER BY fecha_hora DESC LIMIT 3) ;

##no funciona row_number()
SELECT card_id,fecha_hora,declined
ROW_NUMBER() OVER(PARTITION BY card_id ORDER BY fecha_hora DESC) AS rownum
FROM transactions2;


 ###############################



SELECT  count(distinct(id)) AS NumCreditCard,CreditCardInfo
FROM credit_cards2
JOIN (
 SELECT card_id,
 CASE
    WHEN declined = "1" OR declined = "1" OR declined = "1" THEN "Credit Card declined"
    ELSE "Credit Card working" 
END AS CreditCardInfo
FROM transactions2 
ORDER BY fecha_hora DESC  ) Subq1
ON credit_cards2.id = Subq1.card_id
GROUP BY CreditCardInfo;




SELECT distinct(id) AS NumCreditCard,CreditCardInfo
FROM credit_cards2
JOIN (
 SELECT card_id,
 CASE
    WHEN declined = "1" OR declined = "1" OR declined = "1" THEN "Credit Card declined"
    ELSE "Credit Card working" 
END AS CreditCardInfo
FROM transactions2 
ORDER BY fecha_hora DESC  ) Subq1
ON credit_cards2.id = Subq1.card_id;

SELECT card_id
FROM transactions2
WHERE card_id in (
select card_id, 
 CASE
 WHEN SUM(declined) >= 3 THEN "credit card not working"
 ELSE "credit card working"
 END AS CreditCardInfo
 FROM transactions2) 
 GROUP BY card_id;
 


SELECT count(card_id) AS NumCC, card_status
FROM (
SELECT card_id, fecha_hora, declined ,
    CASE 
        WHEN  SUM(declined)  >= 3 THEN 'credit card not working'
        ELSE 'credit card working'
    END AS card_status
    FROM transactions2
GROUP BY card_id 
) Subq1 
group by Subq1.card_status;






##NO FUNCIONA!! Error Code: 1235. This version of MySQL doesn't yet support 'LIMIT & IN/ALL/ANY/SOME subquery'

SELECT*
FROM transactions2
WHERE card_id IN (
SELECT card_id
FROM transactions2
ORDER BY fecha_hora DESC LIMIT 3) ;

##no funciona row_number()
SELECT card_id,fecha_hora,declined
ROW_NUMBER() OVER(PARTITION BY card_id ORDER BY fecha_hora DESC) AS rownum
FROM transactions2;


