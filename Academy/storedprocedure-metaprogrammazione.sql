--STORED PROCEDURE
--STORED PROCEDURE
--STORED PROCEDURE

/*

E' un programma che permette l'esecuzione di più query!

Incapsula pezzi di codice che fa eseguire come se fosse un tutt'uno.

Benefici:
	-avere tutto in un unico luogo
	-ragioni di sicurezza -> non ti dò il permesso di fare una delete, 
							 ma ti dò il permesso di usare una stored procedure che fa quello
	-ragioni di performance (le sp riusano sempre lo stesso PIANO DI ESECUZIONE)

*/

-- creare una stored procedure che mi faccia vedere gli ordini di un certo custid E
-- anche la sua anagarafica in 2 query separate:

create procedure dbo.sp_procedure @custid as int
as
	select * from sales.orders where custid = @custid;
	select * from sales.customers where custid = @custid;

exec dbo.sp_procedure 72

-- stored procedure che crea una tabella temporanea, la popola con una query:
create procedure dbo.sp_temp_employee
as
	drop table if exists #tempEmp

	create table #tempEmp (
		id			int
		,[name]		varchar(20)
		,age		int
		,count_cust	int
	);

	insert into #tempEmp
		
		select
			e.empid
			,e.firstname + ' ' + e.lastname as full_name
			,datediff(year, e.birthdate, getdate()) as age
			,count(o.orderid) as count_cust
		from 
			hr.Employees as e
			inner join
			sales.orders as o
			on e.empid = o.empid
		group by e.empid, e.firstname + ' ' + e.lastname, datediff(year, e.birthdate, getdate()); 
		
	select * from #tempEmp;


exec dbo.sp_temp_employee;

-- parametrizzare la stessa stored procedure di prima:
alter procedure dbo.sp_temp_employee @shipcountry as varchar(30)
as
	create table #tempEmp (
		id			int
		,[name]		varchar(20)
		,age		int
		,count_cust	int
	);

	insert into #tempEmp
		
		select
			e.empid
			,e.firstname + ' ' + e.lastname as full_name
			,datediff(year, e.birthdate, getdate()) as age
			,count(o.orderid) as count_cust
		from 
			hr.Employees as e
			inner join
			sales.orders as o
			on e.empid = o.empid
		where o.shipcountry = @shipcountry
		group by e.empid, e.firstname + ' ' + e.lastname, datediff(year, e.birthdate, getdate()); 
		
	select * from #tempEmp;


exec dbo.sp_temp_employee 'usa';


-- stored procedure che prende 2 paramentri: il primo è l'id del cliente, il secondo quale query fare tra la sales.orders e la sales.customers:
alter procedure dbo.sp_queryCustid @custid as int, @tabella as varchar(20)
as
	if @tabella = 'customer'
	begin
		select * from sales.customers where custid = @custid
	end

	if @tabella = 'orders'
	begin
		select * from sales.orders where custid = @custid
	end;

exec dbo.sp_queryCustid 72, orders
exec dbo.sp_queryCustid 72, customer


-- stored procedure che carica in una tabella data e ora:
-- prima di tutto creo la tabella che conterranno i dati:
create table dbo.dataeora (
	id			int identity(1,1) not null
	,dataEora	datetime
);

-- creo la stored procedure che prende come parametro il numero di volte che voglio caricare data e ora (quindi il numero di righe)
alter procedure dbo.loaddata @n as int
as
	-- pulizia della tabella
	truncate table dbo.dataeora
	-- creo la variabile che fa il conto
	declare @i as int
	set @i = 0

	while @i <= @n
	begin
		insert into dbo.dataeora values (getdate())
		set @i = @i + 1
		-- attesa di 5 secondi prima di far ricominciare il loop
		waitfor delay '00:00:05'
	end;

exec dbo.loaddata 10;

select * from dbo.dataeora;


-- METAPROGRAMMAZIONE
-- METAPROGRAMMAZIONE
-- METAPROGRAMMAZIONE

/*
Non si possono parametrizzare gli oggetti del database -> no tabelle, no campi MA solo valori.
MA se li passo come stringhe e poi li eseguo posso farlo. => metaprogrammazione. Scrivere codice per 
fare del codice.

usare il comando EXEC(), è buona educazione prima vedere se funziona tutto con il PRINT()
*/
print ('select * from sales.orders')
exec ('select * from sales.orders')

-- stored procedure che chiama una tabella:
alter procedure dbo.sp_cercatabella @tabella as varchar(20)
as
	declare @q as varchar(1000) = 'select * from ' + @tabella

	exec (@q) -- importantissimo mettere le ()

exec dbo.sp_cercatabella 'sales.orders'


-- stored procedure che chiama una certa tabella e un parametro. Inoltre posso decidere se vedere stampata la stringa o eseguita
alter procedure dbo.sp_chiamatabella @custid as int, @tabella as varchar(15), @print as int
as
	declare @q as varchar(1000) = 'select * from ' + @tabella
	set @q = @q + ' where custid = ' + cast(@custid as varchar(50))
	
	if @print = 1
		begin
			print(@q)
		end
	else
		begin
			exec(@q)
		end

exec dbo.sp_chiamatabella 1, 'sales.orders', 9

/* ESERCIZIO: crea una tabella che ospiti  campi: orderid, custid, orderdate, freight, dataDiCaricamento
	-dataDiCaricamento è la data e ora in cui sono stati caricati i record nella tabella

	Crea una stored procedure che:
		-carichi per ogni cust id la loro porzioni di dati
		-il caricamento tra un custid e l'altro (la loro porzione di ordini) deve essere di un secondo
		-pulisca tutti i record ogni volta che viene lanciata
*/
create table dbo.esercizio (
	orderid				int			not null
	,custid				int			not null
	,orderdate			date	
	,freight			numeric(8,2)
	,dateload			datetime
);

create procedure dbo.sp_esercizio
as

	-- pulizia tabella
	truncate table dbo.esercizio
	-- definisco il custid, sarà incrementale
	declare @n as int
	set @n = 0
	-- definisco il numero max di clienti presenti
	declare @t as int
	set @t = (select count(*) from sales.customers)

	while @n <= @t
	begin
		insert into dbo.esercizio
			select 
				orderid
				,custid
				,orderdate
				,freight
				,getdate() as dateload
			from sales.orders_test
			where custid = @n;

		set @n = @n + 1
		waitfor delay '00:00:01'
	end

exec dbo.sp_esercizio

select * from dbo.esercizio

-- creo tabella di test dalla sales.orders
select * 
into sales.orders_test
from sales.Orders

-- inserisco nuovi ordini
set identity_insert sales.orders_test on
insert into sales.orders_test 
(orderid,custid,empid,orderdate,requireddate,shippeddate,shipperid,freight,shipname,shipaddress,shipcity,shipregion,shippostalcode,shipcountry) 
values
(111111,91,9,'20220620','20220625',null,358,35.8,'test','test','test','test','test','test')
,(111112,91,9,'20220620','20220625',null,358,35.8,'test','test','test','test','test','test')
,(111113,91,9,'20220620','20220625',null,358,35.8,'test','test','test','test','test','test')
,(111114,91,9,'20220620','20220625',null,358,35.8,'test','test','test','test','test','test')
set identity_insert sales.orders_test off
