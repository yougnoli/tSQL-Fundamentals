-- The FROM Clause
-- The FROM Clause
select
	orderid
	,custid
	,empid
	,orderdate
	,freight
from
	sales.orders
;
go

-- The WHERE Clause
-- The WHERE Clause
select
	orderid
	,custid
	,empid
	,orderdate
	,freight
from
	sales.orders
where
	custid = 71
;
go -- 31 rows


-- The GROUP BY Clause
-- The GROUP BY Clause
select
	empid
	,year(orderdate) as order_year
from
	sales.orders
where
	custid = 71
group by 
	empid
	,year(orderdate)
;
go -- 16 unique combination of empid and year(orderdate) 

-- with aggregate functions
select
	empid
	,year(orderdate) as order_year
	,sum(freight) as total_freight
	,count(*) as num_orders
from
	sales.orders
where
	custid = 71
group by 
	empid
	,year(orderdate)
;
go

-- count(*), count(attribute) and count(DISTINCT attribute)
-- first of all I create a temp table with some values in it:
create table #temp_table (
	attribute int
)
;
go
-- inserting some values in it
insert into #temp_table values
(30)
,(10)
,(null)
,(10)
,(10)
;
go
-- 5 rows affected:
select * from #temp_table
;
go

-- count(*) -> all rows in the column
select
	count(*) as num_rows
from 
	#temp_table
;
go

-- count(attribute) -> all not null rows in the column
select 
	count(attribute) num_not_null_rows
from
	#temp_table
;
go

-- count( DISTINCT attribute) -> count of distinct values in the column
select 
	count( distinct attribute) num_of_distinct_values
from
	#temp_table
;
go

-- DISTINCT can be used with other functions:
select
	sum(attribute) sum_values
from 
	#temp_table
;
go

-- DISTINCT can be used with other functions:
select
	sum(distinct attribute) sum_distinct_30_10
from 
	#temp_table
;
go

-- the number of distinct (different) customers handled by each employee in each order year:
select
	empid
	,year(orderdate) as order_year
	,count(distinct custid) as num_customers
from
	sales.orders
group by
	empid
	,year(orderdate)
;
go
