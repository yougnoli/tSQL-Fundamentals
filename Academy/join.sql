-- JOIN -> operatori tabellari, da 2 o più set, esce un altro set.

-- CROSS JOIN
/*

E' il tipo di join più semplice -> fa il prodotto cartesiano. Prende tutto quello
che c'è nella tabella di sinistra e lo moltiplica per quello che c'è nella tabella di destra.
Questo vuol dire che ogni riga della tabella di sx, matcha ogni riga della tabella di dx

m righe a sinistra 
n righe a destra
righe del nuovo set -> m x n
*/

select
	count(*)
from hr.Employees;

select 
	count(*)
from sales.customers;

select 9 * 91; --819

select 
	c.custid
	,e.empid
from 
	sales.customers as c
	cross join
	hr.employees as e
order by empid;

-- Self Cross-Join
SELECT
  E1.empid, E1.firstname, E1.lastname,
  E2.empid, E2.firstname, E2.lastname
FROM HR.Employees AS E1 
  CROSS JOIN HR.Employees AS E2;

-- INNER
/*

E' una CROSS JOIN a cui è stato aggiunto qualcosa. fa sempre un prodotto 
cartesiano tra le due tabelle di input, ma ci applica un predicato logico che definiamo
nella clausola ON -> filtra le righe

INNER è opzionale perchè è la JOIN di default.

Il predicato logico che passiamo è quello per cui dovranno essere matchati i valori
che escono dai campi che specifichiamo (che saranno uguali tra le due tabelle)
*/

select
	c.custid
	,o.orderid
	,o.orderdate
	,c.city
from 
	sales.customers as c
	inner join
	sales.orders as o
	on c.custid = o.custid;     -- ci restituisce solo i record per cui questa è vera

select
	c.custid
	,o.orderid
	,o.orderdate
	,c.city
from 
	sales.customers as c
	inner join
	sales.orders as o
	on 1=1;							-- infatti questa è una cross join


-- Multi-Join Queries
SELECT
  C.custid
  ,C.companyname
  ,O.orderid
  ,OD.productid
  ,OD.qty
FROM 
	Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
    ON C.custid = O.custid
	INNER JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid;

-- OUTER
/*
è una INNER che recupera i dati, o dalla tabella di sinistra, di destra o da tutto il set. 
La tabella che specifico è la tabella che voglio 'PRESERVARE'.
Il match delle tabelle che voglio fare la JOIN è fondamentale
*/

-- left/right/full

select
	c.custid
	,o.orderid
	,c.companyname
	,o.orderdate
from	
	sales.orders as o
	left outer join
	sales.customers as c
	on o.custid = c.custid
; -- 830 righe

select
	c.custid
	,o.orderid
	,c.companyname
	,o.orderdate
from	
	sales.customers as c
	left outer join
	sales.orders as o
	on o.custid = c.custid
; -- 832 righe

-- clienti che non hanno fatto ordini:
select
	c.custid
	,o.orderid
	,c.companyname
	,o.orderdate
from	
	sales.customers as c
	left outer join
	sales.orders as o
	on o.custid = c.custid
where o.orderid is null;

-- posso fare anche un'ulteriore join sul set di dati che esce da un'altra join:
select
	c.custid
	,o.orderid
	,e.empid
	,c.companyname
	,o.orderdate
from	
	sales.customers as c
	left outer join
	sales.orders as o
	on o.custid = c.custid
	inner join
	hr.Employees as e
	on e.empid = o.empid; -- 830 righe mi sono riperso i 2 customer che non hanno fatto ordini


-- quando left/right/full outer join sono uguali:
--LEFT
select
	c.custid
	,o.orderid
	,c.companyname
	,o.orderdate
from	
	sales.customers as c
	left outer join
	sales.orders as o
	on o.custid = c.custid
; -- 832 righe

--RIGHT
select
	c.custid
	,o.orderid
	,c.companyname
	,o.orderdate
from	
	sales.orders as o
	right outer join
	sales.customers as c
	on o.custid = c.custid
; -- 832 righe

--FULL 1
select
	c.custid
	,o.orderid
	,c.companyname
	,o.orderdate
from	
	sales.orders as o
	full outer join
	sales.customers as c
	on o.custid = c.custid
; -- 832 righe

--FULL2
select
	c.custid
	,o.orderid
	,c.companyname
	,o.orderdate
from	
	sales.customers as c
	full outer join
	sales.orders as o
	on o.custid = c.custid
; -- 832 righe
