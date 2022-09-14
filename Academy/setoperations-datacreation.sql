
-- OPERAZIONI TRA I SET: UNION/INTERSECT/EXCEPT
-- OPERAZIONI TRA I SET: UNION/INTERSECT/EXCEPT
-- OPERAZIONI TRA I SET: UNION/INTERSECT/EXCEPT

/*

Non affianco le tabelle (come per le JOIN), ma lavorano sui record.

CARATTERISTICHE:
	-I due set non possono avere l'ORDER BY, ma è possibile metterla alla fine delle operazioni dei set (*)
	-i set devono avere lo stesso nuemro di colonne (**)
	-i campi allineati verticalmente devono avere lo stesso datatype (***)

*/

-- UNION
-- UNION
-- aggiunge al primo set le righe del secondo set, che però non sono contenute nel primo. 
SELECT country,city FROM HR.Employees -- 9 righe
UNION															--> TOT 71 RIGHE  ELIMINA i duplicati
SELECT country,city FROM Sales.Customers; -- 91 righe				la DISTINCT dopo UNION è sottointeso

-- UNION ALL
-- UNION ALL
-- riporta tutte le righe di entrambi i set, senza fare controli di alcun tipo
SELECT country,city FROM HR.Employees -- 9 righe
UNION ALL													--> TOT 100 RIGHE (9+91)	NON elimina i duplicati
SELECT country,city FROM Sales.Customers; -- 91 righe

-- Domanda: quante sono le righe di un'operazione sui set di questo tipo? -> 71, perchè alla fine c'è la
select country, city from sales.Customers								--   UNION che fa da distinct
union all
select country, city from hr.Employees
union 
select country, city from sales.Customers;

-- Domanda: quante sono le righe di un'operazione sui set di questo tipo? -> 162, perchè alla fine c'è la
select country, city from sales.Customers								--   UNION ALL che fa la somma dei primi
union																	--   71 con i secondi 91
select country, city from hr.Employees
union all
select country, city from sales.Customers;


select 71+91; --> 162

-- test order by (*)
select country, city from sales.Customers								
union																	
select country, city from hr.Employees
union all
select country, city from sales.Customers
order by country;

-- test numero colonne (**)
select city from sales.Customers								
union																	
select country, city from hr.Employees;

-- test datatype (***)
select custid, city from sales.Customers								
union																	
select country, city from hr.Employees;

--> soluzione: converto il datatype MA IL RISULTATO E' SBAGLIATO
select cast(custid as varchar(20)) as campo, city from sales.Customers								
union																	
select country, city from hr.Employees;


-- INTERSECT
-- INTERSECT
-- riporta solo le righe che hanno in comune i due set 
SELECT country, city FROM HR.Employees
INTERSECT
SELECT country, city FROM Sales.Customers;

-- come gestisce i NULL? Per SQL solo nelle operazioni tra i SET li considera uguali
SELECT country, region, city FROM HR.Employees
INTERSECT
SELECT country, region, city FROM Sales.Customers;
            

-- EXCEPT
-- EXCEPT
-- restituisce le righe che sono presenti nel primo set, ma non sono presenti nel secondo set

-- Employees EXCEPT Customers
SELECT country, region, city FROM HR.Employees
EXCEPT
SELECT country, region, city FROM Sales.Customers;

-- Customers EXCEPT Employees
SELECT country, city FROM Sales.Customers
EXCEPT
SELECT country, city FROM HR.Employees;

/*

 PRECEDENZA degli operatori dei set: 
	-INTERSECT precede l'UNION e l'EXCEPT
	-UNION ed EXCEPT sono considerati uguali
 
 Quindi nelle query dove ci sono molteplici operatori dei set, prima vengono valutati gli
 INTERSECT e poi vengono valutati gli UNION e gli EXCEPT nell'ordine in cui appaiono.

*/

-- esempio:
select country, city from hr.Employees
EXCEPT
select country, city from sales.customers
INTERSECT
select country, city from Production.Suppliers

/*

Prima viene valutata l'intersect: quindi paesi e citta che sono sia nei customers che nei suppliers. 
Poi viene valutata l'except: prende solo i record distinti che ci sono nel primo set, ma non compaiono nel secondo
Infatti il record che viene lasciato fuori è UK|London (perchè si trova in entrambi i set).

*/

-- NOTA: per controllare l'ordine di valutazione delle operazioni, usare le PARENTESI!

-- ESERCIZI:

--recuperare l'elenco dei custid, empid, orderdate che hanno effettuato ordini in luglio 2014, ma non in agosto 2014
select custid, empid, orderdate from sales.orders where year(orderdate) = 2014
except
select custid, empid, orderdate from sales.orders where year(orderdate) = 2014 and month(orderdate) <> 7

--recuperare l'elenco dei custid che hanno effettuato ordini sia in luglio 2014, che in agosto 2014 che in agosto 2015
select custid from sales.orders where year(orderdate) = 2014 and month(orderdate) = 7
intersect	  
select custid from sales.orders where year(orderdate) = 2014 and month(orderdate) = 8
intersect	  
select custid from sales.orders where year(orderdate) = 2015 and month(orderdate) = 8

-- recuperare l'elenco dei custid che hanno effettuato ordini sia in luglio 2014, che in agosto 2014 ma non in agosto 2015
select custid from sales.orders where year(orderdate) = 2014 and month(orderdate) = 7
intersect
select custid from sales.orders where year(orderdate) = 2014 and month(orderdate) = 8
except
select custid from sales.orders where year(orderdate) = 2015 and month(orderdate) = 8


-- DATA CREATION		
-- DATA MODIFICATION
-- DATA CREATION		
-- DATA MODIFICATION


/*
Creare una tabella innanzi tutto prevede diversi step:
	-usare un certo database -> USE
	-usare un cert schema -> non metterlo = usare quello di default (DBO)
	-creare la tabella -> CREATE TABLE
	-per ogni campo che inseriamo nella tabella -> nome campo | datatype |se accetta NULL o non può averne (NOT NULL)

*/


create table anagrafica (
	
	id			int				not null
	,nome		varchar(20)		not null
	,età		int				null
);

select * from dbo.anagrafica;

/*
STATEMENT PER I RECORD:
	-INSERT
	-UPDATE
	-DELETE
*/

/*
STATEMENT PER OGGETTI:
	-CREATE
	-ALTER
	-DROP
*/

-- Inserire dentro la tabella dei record
insert into dbo.anagrafica values
	(1, 'mario', 55)
	,(2, 'giuseppe', 36);

select * from dbo.anagrafica;

-- Inserire record non esatti:
insert into dbo.anagrafica values
	(1, 'mario', 55)
	,(3, 'lucia', 36);

-- Inserire record con il campo id null:
insert into dbo.anagrafica values
	('mario', 55)

insert into dbo.anagrafica (nome, età) values
	('mario', 55)

-- inserire solo 2 campi specifici:
insert into dbo.anagrafica (id, nome) values
	(1, 'mario')

select * from dbo.anagrafica


-- modo veloce per POPOLARE una tabella: -> query
insert into dbo.anagrafica
	select empid, firstname, datediff(year, birthdate, getdate())
	from Test_C001.hr.Employees

-- modo veloce per CREARE una tabella: -> INTO prima della FROM
-- NOTA: in questo modo tutti i campi avranno il datatype nvarchar(max): è una pratica quick and dirty
select 
	empid
	,firstname
	,datediff(year, birthdate, getdate()) as birthday
into impiegati
from Test_C001.hr.Employees;

select * from dbo.impiegati;


-- eliminare record:
delete from dbo.anagrafica
where nome = 'Mario'
-- NOTA: il delete è irreversibile
select * from dbo.anagrafica;


-- modificare il valore dei record:
update dbo.anagrafica
	set nome = 'Paolo', età = 36
	where id = 2

select * from dbo.anagrafica;

-- PRIMARY KEY -> garantisce l'unicità di una riga e non permette i NULL nel campo.
-- problema che il nostro campo id NON è UNIVOCO:
create table anagarafica2 (
	id		int				identity(1, 1)	not null	primary key
	,nome	varchar(20)						not null
	,età	int								null
);

-- check tabella vuota
select * from dbo.anagarafica2;

-- inserisco i dati dalla tabella con id sbagliati
insert into dbo.anagarafica2 
	select nome, età
	from dbo.anagrafica;

-- check tabella:
select * from dbo.anagarafica2;

-- FOREIGN KEY -> voglio dare una regola di integrità che restringe i valori che possono entrare in una certa tabella.
-- fa un controllo prima se esistono nella tabella di riferimento, così può dare il permesso di essere inseriti nella nostra tabella.
--es:
select * from dbo.impiegati --> 9 id

select * from dbo.anagarafica2 --> 11 id

-- metto come FK il campo empid della tabella dbo.impiegati, come riferimento la dbo.anagarafica2
-- quindi possono entrare gli id nella dbo.impiegati solo se esistono nella dbo.anagarafica2
alter table dbo.impiegati
	add constraint fk_empid_imp
	foreign key (empid)
	references dbo.anagarafica2(id);


set identity_insert dbo.impiegati on

insert into dbo.impiegati (empid, firstname, birthday) values 
	(25, 'Mario', 99);

insert into dbo.impiegati (empid, firstname, birthday) values 
	(10, 'Mario', 99);

set identity_insert dbo.impiegati off

-- CHECK -> è un vincolo che una riga deve mantenere per poter entrare a far parte della tabella:
alter table dbo.anagarafica2
	add constraint chk_age
	check(età > 0);

-- inserisco un record di un impiegato che ha -37 anni
select * from dbo.anagarafica2;

insert into dbo.anagarafica2 values 
('giuseppe', -37);


insert into dbo.anagarafica2 values 
('giuseppe', 37);

select * from dbo.anagarafica2;

update dbo.anagarafica2
	set nome = 'Giuseppe'
	where id = 13;


-- DEFAULT -> vincolo che mi mette un valore di default nel caso non fosse passato nessun valore
alter table NOMEtabella
	add constraint def
	default (getdate()) for CAMPO



-- modificare un datatype di un campo in una tabella:
ALTER TABLE dbo.anagarafica2 
ALTER COLUMN nome VARCHAR (50);

-- eliminare una colonna

-- aggiungere un campo calcolato

-- NOTA sul DELETE -> il TRUNCATE TABLE è un comando che non ha la where. 
-- Se volessi eliminare tutti i record di una tabella (senza eliminare la tabella e la sua struttura) questo statement è perfetto.
select * from dbo.elimina;

truncate table dbo.elimina;

--TABELLE TEMPORANEE
/*
Le tabelle temporanee sono utili quando voglio storare dei dati da qualche parte ma non in maniera temporanea, quindi non mi conviene usare
le tabelle permanenti.

Per esempio potrei avere bisogno di una tabella solo all'interno di una certa connessione se non addirittura dentro un certo batch.

Ci sono 3 tipi di tabelle temporanee:
	-LOCAL TBEMPORARY
	-GLOBAL TEMPORARY
	-TABLE VARIABLE

Tutti questi tipi di tabelle sono storati dentro il TEMPDB DATABASE
*/

-- LOCAL TEMPORARY TABLE -> visibile solo dentro alla stessa connessione, si crea mettendo # davanti, sono tabelle distrutte automaticamente da SQL SERVER
-- questi tipi di tabelle sono utili quando c'è bisogno di storare dati in una fase intermedia del progetto o dello stesso script.

-- es: mostrare con tabelle temporanee la quantità totale per anno e per anno precedente.

select
	year(o.orderdate) as orderyear
	,sum(qty) as totqty
INTO #t1
from 
	sales.orders as o
	left outer join
	sales.OrderDetails as od
	on o.orderid = od.orderid
group by year(o.orderdate);


select
	curr.orderyear
	,curr.totqty as curr
	,prev.totqty as prev
from
	dbo.#t1 as curr
	left outer join
	dbo.#t1 as prev
on curr.orderyear = prev.orderyear + 1
order by curr.orderyear;

-- le tabelle temporanne possono essere il punto di partenza per la creazione di tabelle permanenti
select
	curr.orderyear
	,curr.totqty as curr
	,prev.totqty as prev
into elimina
from
	dbo.#t1 as curr
	left outer join
	dbo.#t1 as prev
on curr.orderyear = prev.orderyear + 1
order by curr.orderyear;

-- ERRORE: non è possibile creare viste da tabelle temporanee
create view dbo.vw_elimina
as
	select
	curr.orderyear
	,curr.totqty as curr
	,prev.totqty as prev
from
	dbo.#t1 as curr
	left outer join
	dbo.#t1 as prev
on curr.orderyear = prev.orderyear + 1



-- GLOBAL TEMPORARY TABLE -> tabelle visibili anche in altre connesioni, ma solo finchè la connessione in cui è stata creata
-- continua ad essere 'viva'. Sono comode quando si vuole condividere dati temporanii con altre connessioni. Sono create con ##

-- TABLE VARIABLES
/*
Tabelle create con lo statement DECLARE. Sono visibili solo all'intero della connessione in cui sono state create e nello stesso batch.
*/

declare @table_variable table
	(
		orderyear	int		not null
		,totqty		int		not null
	);

insert into @table_variable (orderyear, totqty)
	select
		year(o.orderdate) as orderyear
		,sum(qty) as totqty
	from 
		sales.orders as o
		left outer join
		sales.OrderDetails as od
		on o.orderid = od.orderid
	group by year(o.orderdate);


select * from @table_variable;
