-- DATA TYPE
-- DATA TYPE
-- DATA TYPE

declare @data as date = '20220605'
select @data;

declare @data as date = '20221505'  -- errore
select @data;

declare @intero as int = 20
select @intero;

declare @intero as int = 2.55  -- lo trasforma in intero
select @intero;

declare @decimale as numeric(4,2) = 55.55
select @decimale;

declare @stringa as char(1) = 'pippo' -- occupa esattamente 1 carattere
select @stringa;

declare @stringavar as varchar(5) = 'pippo pluto'  -- occupa al massimo 5 caratteri. Se passo 'ugo', occupererà 3 e non 5
select @stringavar;

/*
SQL supporta la creazione di queries, dentro altre queries.
Abbiamo una query più esterna e una più interna.

Perchè usare delle subquery? Perchè ci evita l'utilizzo di variabili o altre oggetti 
in cui dobbiamo storare il nostro set di dati.
*/

-- SUBQUERY SCALARE
-- Subquery che restituisce un singolo valore:

-- voglio l'informazione dell'ordine del max orderid della tabella:

-- registro l'informazione dentro una variabile:
declare @max_id as int =	(select max(orderid)
								from sales.orders)

-- chiamo quella variabile ( dove dentro c'è già il max(orderid) ) nella where
select *
from sales.Orders
where orderid = @max_id;

-- posso passare da una query che è divisa in 2 step, a una query unica
-- che ha al suo interno un'altra query:
select *
from sales.orders
where orderid = (select max(orderid)
				from sales.orders);

-- NOTA: una subquery scalare DEVE riportare un solo valore, più di uno darebbe errore:
select * from hr.Employees;

-- voglio vedere gli ordini degli impiegati che iniziano per 'P' -> ERRORE (più di un valore)
select orderid
from sales.orders
where empid = (select empid
				from hr.Employees
				where firstname like 'P%');

-- voglio vedere gli ordini degli impiegati che iniziano per 'D' -> NO ERRORE (un solo nome che inizia per D)
select orderid
from sales.orders
where empid = (select empid
				from hr.Employees
				where firstname like 'D%');



-- SUBQUERY MULTIVALORE

-- Utilizzo del predicato IN:
select orderid, empid
from sales.orders
where empid in (select empid
				from hr.Employees
				where firstname like 'P%'); -- questa volta non mi dà errore

-- utilizzo dell'EXISTS: va messo nella WHERE perchè restutuisce TRUE per tutto quello che c'è nella subquery
select * 
from Sales.Orders as a
where exists  (
				select 
					orderid
				from 
					sales.orders as b
				where 
					a.orderid = b.orderid	-- dove fare il check del TRUE
					and 
					orderid % 2 = 0			-- solo le righe che hanno ordini pari
				)

-- queste query si possono risolvere in diversi modi: es una JOIN
select o.orderid, e.empid
from 
	sales.orders as o
	inner join
	hr.Employees as e
	on e.empid = o.empid
where e.firstname like 'P%';

-- NOTA: non c'è un modo migliore per avere questo set di risultato, alcune volte
-- è più comodo fare un join altre volte una subquery

-- ESERCIZIO: scrivere una query che mi ritorni le info degli ordini 
-- dei customers che NON provengono dagli usa -> usare subquery
select 
	custid
	,orderid
	,orderdate
	,empid
from sales.orders
where custid not in (select c.custid 
				from sales.Customers as c 
				where country = 'USA');

-- vedere i clienti che non hanno fatto ordini senza fare delle JOIN:
select 
	custid
	,companyname
from sales.customers
where custid not in (select o.custid 
					from sales.orders as o);

-- SUBQUERY CORRELATE
-- dove la subquery è dipendente dalla outer query -> non può esistere da sola

-- voglio vedere per ogni customer il suo max ordine

select custid, orderid
from sales.orders as a
where orderid = (select max(b.orderid)
				from sales.orders as b
				where a.custid = b.custid)
order by custid;

select * from sales.orders where custid = 85; -- max orderid è 10,739
select max(orderid) from sales.orders where custid = 85; -- questa mi trova il max ordine (è la subquery). Il custid nella where
														 -- però lo deve cercare nella outer query. infatti where a.custid = b.custid

-- TABLE EXPRESSIONS
-- TABLE EXPRESSIONS
-- TABLE EXPRESSIONS
-- TABLE EXPRESSIONS


 /*
 Esistono diversi tipi di table expressions:
	- Subquery
	- CTEs
	- Viste
	- TVF
 
 Queste non sono fisicamente materializzate da nessuna parte, sono virtuali. Una query su una TABLE EXP è una query
 sull'oggetto che vive al di sotto di essa. 
 Semplificano il codice, non le creiamo per migliorare le performance
 
 */

 -- SUBQUERY
 -- SUBQUERY

 -- Sono anche dette tabelle derivate ed esistono nella clausola FROM. 
 -- Una volta che l'outer query è terminata, la tabella derivata cessa di esistere.
 -- Definiamo la tabella derivata 1) tra parentesi 2) con un alias finale

 -- customer che provengono dagli USA:
 select *
 from (select custid, companyname
		from sales.Customers
		where country = 'USA') as CustUsa;

/*
NOTA: Caratteristiche di una Table Expression:
	- l'ordine NON è garantito (quindi non posso usare l'order by, a meno non specifichi anche una TOP)
	- nome dei campi nella table exp deve essere unico
	- tutte le colonne devono avere un nome
*/

-- benefici degli alias: fare riferimento ad essi nella outer query
select anno, tot
from (
		select 
			year(orderdate) as anno
			,sum(freight) as tot
		from sales.orders
		group by year(orderdate)
	) as subq
order by anno;

-- utilizzare le variabili per definire un argomento: contare quanti clienti diversi ha servito un certo impiegato per anno
declare @e as int = 3

select 
	year(orderdate) as anno
	,custid
from sales.orders
-- where empid = @e
order by anno, custid
; -- attenzione ai duplicati

declare @e as int = 3

select anno, count(distinct custid) as num_cust
from (
		select 
			year(orderdate) as anno
			,custid
		from sales.orders
		where empid = @e
	) as subq
group by anno
order by num_cust; 


-- CTEs
-- CTEs

-- molto simile alle tabelle derivate, ma presentano la clausola WITH
-- non appena la query finisce la cte muore

with cteUsaCust
as
(
	select custid, companyname
	from sales.customers
	where country = 'USA'
)

select *
from cteUsaCust;

-- anche le cte reggono la creazione di variabili:
declare @e as int = 3; -- deve terminare con un ; qundo dopo c'è il with

with cteA
as 
(
	select
		year(orderdate) as anno
		,custid
	from sales.orders
	where empid = @e
)

select 
	anno, count(distinct custid) as tot_cust
from cteA
group by anno;


-- chiamare più cte nella stessa query: basta mettere dopo la prima cte la ',' e poi il nome della nuova cte

-- ESERCIZIO: usando le cte voglio vedere in ordine decrescente il tot degli ordini distinti di ogni
-- per l'anno 2015. Da una cte prenderemo il full_name dell'impiegato. Dall'altra cte prendiamo ordini.
with cteA
as
(
	select 
		empid
		,concat(firstname, ' ', lastname) as full_name
	from hr.Employees
),

cteB
as
(
	select 
		empid
		,orderdate
		,orderid
	from sales.orders
)

select 
	year(orderdate) as anno
	,count(distinct orderid) as tot_ord
	,full_name
from 
	cteA
	inner join
	cteB
	on cteA.empid = cteB.empid
where year(orderdate) = 2015
group by year(orderdate), full_name
order by tot_ord desc;


/*
NOTA: le subquery e le cte hanno uno scopo di azione limitato, cioè il singolo statement. Non appena l'outer query ha finito di runnare
loro sono esaurite.Per questo motivo non sono riutilizzabili.
Le VISTE  e le TABLE FUNCTIONS invece sono riutilizzabili.
Una volte create queste (VISTE e TABLE FUNCTIONS) sono storate dentro al database e per essere eliminate devono essere esplicitamente droppate.
*/

-- VISTE
-- VISTE

-- Creare una VISTA per solo i customer degli usa, prima con una cte o una SUBQUERY avremmo fatto così:
select *
from (
	select *
	from sales.orders
	where shipcountry = 'USA'
	) as a
;

-- NOTA: creare oggetti dentro a uno script sql -> create OGGETTO NOME as
create schema vista

-- Ma questa non è riutilizzabile. Una vista invece me la salva e posso richiamarla quanto voglio.
create view vista.vw_ordersUsa
as
	select *
	from sales.Orders
	where shipcountry = 'USA'
;

select * from vista.vw_ordersUsa
;

-- IMPORTANTE: evita il più possibile di usare il SELECT * di una tabella dentro una vista.
-- Specifica sempre quali tabelle vuoi portarti dietro. Se una colonna viene aggiunta alla tabella,
-- non me la ritroverò nella vista. Quindi devo fare ALTER VIEW e aggiungere il campo a mano. 
-- Diverso invece se vengono aggiunti record, quelli me li ritrovo nella vista

-- allora la modifico:

alter view vista.vw_ordersUsa
as
	select
		orderid
		,custid
		,empid
		,orderdate
		,freight
		,shipcity
		,shipregion
		,shipcountry
	from sales.orders
	where shipcountry = 'USA';

-- check
select * from vista.vw_ordersUsa;

-- ERRORE: mettere l'order by in una vista
alter view vista.vw_ordersUsa
as
	select
		orderid
		,custid
		,empid
		,orderdate
		,freight
		,shipcity
		,shipregion
		,shipcountry
	from sales.orders
	where shipcountry = 'USA'
	order by freight desc;

-- con una top me lo fa fare:
alter view vista.vw_ordersUsa
as
	select top 100
		orderid
		,custid
		,empid
		,orderdate
		,freight
		,shipcity
		,shipregion
		,shipcountry
	from sales.orders
	where shipcountry = 'USA'
	order by freight desc;

-- check:
select * from vista.vw_ordersUsa;

-- voglio parametrizzare una vista, in modo tale da poter interrogare un oggetto senza dover ogni volta
-- specificare nella where quale paese andare a vedere. 

-- TABLE FUNCTIONS
-- TABLE FUNCTIONS

create function dbo.OrderCountry (@paese varchar(20)) returns table
as
return
	select
		orderid
		,custid
		,empid
		,orderdate
		,freight
		,shipcity
		,shipcountry
	from sales.orders
	where shipcountry = @paese;

-- check sul paese 'Italy'
select *
from dbo.OrderCountry('Italy');

-- check sul paese 'Usa'
select *
from dbo.OrderCountry('USA');

-- ESERCIZIO: voglio vedere gli ultimi 10 ordini di ogni customer in ordine decrescente. Customer è il parametro.
alter function dbo.last10orders (@custid as int) returns table
as
return
	select top 10
		orderid
		,orderdate
		,freight
	from sales.orders
	where custid = @custid
	order by orderdate desc;

-- check:
select * from dbo.last10orders(72);
select * from dbo.last10orders(73);

-- Parametrizzare il numero di record da vedere e il paese in una table functions che presenti i campi:
-- orderid custid empid orderdate  freight companyname country full_name dell'employee
create function dbo.ordersParam (@top as int, @country as varchar(20)) returns table
as
return
	select top (@top)
		o.orderid
		,o.custid
		,e.empid
		,o.orderdate
		,o.freight
		,c.companyname
		,c.country
		,concat(e.firstname, ' ', e.lastname) as full_name
	from 
		sales.orders as o
		inner join
		hr.employees as e
		on e.empid = o.empid
		inner join 
		sales.customers as c
		on c.custid = o.custid
	where c.country = @country
	order by orderdate desc;


-- esercizio difficile: convertitore numeri romani:
create function dbo.[RomanNumeral] (@RomanNumeral varchar(10))  returns int as
BEGIN
	declare @Length int
	set @Length = len(@RomanNumeral)

	declare @Counter int = 1
	declare @Character char(1)
	declare @CurrentValue int = 0
	declare @LastValue int = 0
	declare @Value int = 0



	while (@Counter <= @Length)
	begin
		set @Character = substring(@RomanNumeral, @Counter, 1)
		set @CurrentValue =
		(case when @Character = 'I' then 1
		when @Character = 'V' then 5
		when @Character = 'X' then 10
		when @Character = 'L' then 50
		when @Character = 'C' then 100
		when @Character = 'D' then 500
		when @Character = 'M' then 1000
		else 0 end)

		if @LastValue = 0
		begin
		set @LastValue = @CurrentValue
		end
		else if (@LastValue >= @CurrentValue)
		begin
		set @Value += @LastValue
		set @LastValue = @CurrentValue
		end
		else if (@LastValue <= @CurrentValue)
		begin
		set @Value += (@CurrentValue - @LastValue)
		set @LastValue = 0
		end

		set @Counter = @Counter + 1
	end



	if @LastValue > 0
	set @Value += @LastValue

RETURN @Value
END

-- check:
select * from dbo.ordersParam(3, 'France');

-- CROSS APPLY
-- CROSS APPLY

-- cross apply => prodotto cartesiano
select * 
from 
	sales.orders as o
	cross apply
	sales.customers as c --75,530


select 830*91 --75,530

-- tutto quello che c'è nella tabella di destra è ripetuto per ogni riga della tabella di sinistra
-- se nella tabella di destra c'è una table expression allora mi ripete quella table per ogni record della tabella di sinistra

--per ogni customer voglio vedere i suoi ultimi 3 ordini:
-- creo la table function dbo.last3orders

create function dbo.last3orders (@custid as int) returns table
as
return
	select top 3
		orderid
		,orderdate
		,freight
	from sales.orders
	where custid = @custid
	order by orderdate desc;

-- la applico ad ogni customer che esce dalla sales.customer:
select
	c.custid
	,tvf.orderid
	,tvf.orderdate
	,tvf.freight
from	
	sales.customers as c
	cross apply
	dbo.last3orders(c.custid) as tvf
order by custid, orderdate; -- 263

select 89*3 -- 267

-- perchè non torna il calcolo 89*3 ?
select
	c.custid
	,count(tvf.orderid) as num_orders
from	
	sales.customers as c
	cross apply
	dbo.last3orders(c.custid) as tvf
group by c.custid
having count(tvf.orderid) <> 3
order by custid; -- ci sono 3 clienti che non arrivano a 3 ordini -> tot ordini che mancano sono 4


--ESERCIZIO: tirare fuori il BMI per ogni persona della tabella dbo.people100a

use PoriniSqlEdu
;
go

select givenname, surname, kilograms, centimeters from dbo.People100a

alter function dbo.bmi (@peso numeric(5,2), @altezza numeric(5,2)) returns table
as
return
	select 
		(@peso / (@altezza/100.0 * @altezza/100.0)) as bmi 

--test
select * from dbo.bmi(81, 180)

select 
	a.givenname
	,a.surname
	,a.kilograms
	,a.centimeters
	,b.bmi
from 
	dbo.People100a as a
	cross apply
    dbo.bmi(a.kilograms, a.centimeters) as b
;

alter function dbo.bmi2 (@peso as numeric(5,2), @altezza as numeric(5,2), @compleanno as date) returns table
as
return
	select
		(@peso / ((@altezza/100.0)*(@altezza/100.0))) as bmi
		,datediff(year, @compleanno, getdate()) as età
		,case 
			when (@peso / ((@altezza/100.0)*(@altezza/100.0))) < 15.0 then 'Sottopeso'
			when (@peso / ((@altezza/100.0)*(@altezza/100.0))) > 35.0 then 'Sovrappeso'
			else 'Normopeso'
		end as 'Result'
