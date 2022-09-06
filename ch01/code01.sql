/*
create a database testdb if database testdb does not exist. This type of database creation sets default settings in terms of file 
location and initial size. In production environment you have to specify those settings.
*/
if db_id('testdb') is null
	create database testdb
;
go

/*
change the current database to that of testdb
*/
use testdb
;
go

/*
For creating a table I will use default schema: dbo, that is created automatically in every database.
*/
if object_id('dbo.employees', 'U') is not null
	drop table dbo.employees
;
go

create table dbo.employees (
	empid		int				not null
	,firstname	varchar(30)		not null
	,lastname	varchar(30)		not null
	,hiredate	date			not null
	,mgrid		int				null
	,ssn		varchar(20)		not null
	,salary		money			not null
)


-- PRIMARY KEY
/*
primary key constraint on the empid column in the employees table
*/
alter table dbo.employees
	add constraint pk_employees
	primary key (empid)
;
go

-- UNIQUE CONSTRAINT
/*
unique constraints on the ssn column in the employees table
*/
alter table dbo.employees
	add constraint unq_employees_ssn
	unique (ssn)
;
go

/*
create a table called orders with a primary key defined on the orderid
*/
if object_id('dbo.orders', 'U') is not null
	drop table dbo.orders
;
go

create table dbo.orders (
	orderid		int			not null
	,empid		int			not null
	,custid		varchar(10)	not null
	,orderts	datetime	not null
	,qty		int			not null
	,constraint pk_orders primary key (orderid)
)
;
go

-- FOREIGN KEY
/*
restrict the domain of values supported by the empid column in the Orders table to the values that exist in the empid column in the employees table.
*/
alter table dbo.orders
	add constraint fk_orders_employees
	foreign key (empid)
	references dbo.employees (empid)
;
go

/*
similarly for restrict the domain of values supported by the mgrid column to the values that exist in the empid column
*/
alter table dbo.employees
	add constraint fk_employees_employees
	foreign key (mgrid)
	references employees (empid)
;
go

-- CHECK CONSTRAINT
/*
ensure that the salary column will support only positive values
*/
alter table dbo.employees
	add constraint chk_employees_salary
	check (salary > 0)
;
go

-- DEFAULT CONSTRAINT
/*
constraint for the orderts attribute: when not provided a value the current_timestamp function will insert one)
*/
alter table dbo.orders
	add constraint dft_orders_orderts
	default (current_timestamp) for orderts
;
go

-- verification of all constraints:
-- PRIMARY KEY
-- PRIMARY KEY
insert into dbo.employees values
(1, 'mario', 'rossi', '20220101', 1, 'abc123', 20000)
,(2, 'giulia', 'bianchi', '20220101', 1, 'def456', 30000)
;
go
-- 2 rows affected
select * from dbo.employees
;
go
-- violation of primary key constraint: empid is the same for mario rossi
insert into dbo.employees values
(1, 'franco', 'moretti', '20220101', 1, 'ghi789', 20000)
;
go

-- UNIQUE CONSTRAINT
-- UNIQUE CONSTRAINT
-- check of the table:
select * from dbo.employees
;
go
-- inserting a row with correct empid (I don't want violate primary key constraint), but not unique ssn:
insert into dbo.employees values
(5, 'alessio', 'marconi', '20220101', 1, 'abc123', 20000) 
;
go
-- error:
-- Violation of UNIQUE KEY constraint 'unq_employees_ssn'. Cannot insert duplicate key in object 'dbo.employees'. The duplicate key value is (abc123).

-- FOREIGN KEY
-- FOREIGN KEY
insert into dbo.orders values
(1, 1, 'cust01', '20220101', 100)
;
go
-- 1 row affected
select * from dbo.orders
;
go
-- the insert statement conflicted with the foreign key constraint -> there is no empid 100 in the dbo.employees table
insert into dbo.orders values
(2, 100, 'cust01', '20220101', 100)
;
go

-- CHECK CONSTRAINT
-- CHECK CONSTRAINT
insert into dbo.employees values
(3, 'giulio', 'verdi', '20220101', 1, 'jkl123', 20000)
,(4, 'giulia', 'bianchi', '20220101', 1, 'mno456', 30000)
;
go
-- 2 rows affected
select * from dbo.employees
;
go
-- The insert statement conflicted with the CHECK constraint -> salary must be > 0
insert into dbo.employees values
(5, 'rocco', 'morelli', '20220101', 1, 'pqr789', -10000)
;
go

-- DEFAULT CONSTRAINT
-- DEFAULT CONSTRAINT
-- purpusly missing orderts value (I have to specify other columns because I'm not filling everyone)
insert into dbo.orders (orderid, empid, custid, qty) values
(2, 1, 'cust02', 1000)
;
go
-- 1 row affected: orderts is the actual insertion time
select * from dbo.orders
;
go
