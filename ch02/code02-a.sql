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

-- The HAVING Clause
-- The HAVING Clause
-- from the previous query, I want only groups with more than 1 orders:
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
having count(*) > 1
;
go

-- The SELECT Clause
-- The SELECT Clause
-- by mistake don't specify the comma between column names
select
	orderid orderdate --> I'm unknowingly aliasing 
from
	sales.orders
;
go

-- refer to expression aliases in clauses that are processed prior to the SELECT clause:
-- this gives me an error: WHERE is processed before the SELECT
select
	orderid
	,year(orderdate) as order_year
from 
	sales.orders
where
	order_year > 2020  --> Invalid column name 'order_year'
;
go
-- to solve this problem:
select
	orderid
	,year(orderdate) as order_year
from 
	sales.orders
where
	year(orderdate) > 2020
;
go

-- query without a DISTINCT Clause
select
	empid
	,year(orderdate) as order_year
from
	sales.orders
where custid = 71
;
go --> 31 rows 
-- query with a DISTINCT Clause
select distinct
	empid
	,year(orderdate) as order_year
from
	sales.orders
where custid = 71
;
go --> 16 rows

-- In the SELECT clause I cannot refer to a column alias
-- wrong way:
select
	orderid
	,year(orderdate) as order_year
	,order_year + 1 as next_year
from
	sales.orders
;
go
-- correct way:
select
	orderid
	,year(orderdate) as order_year
	,year(orderdate) + 1 as next_year
from
	sales.orders
;
go

-- The ORDER BY Clause
-- The ORDER BY Clause
select 
	empid
	,year(orderdate) as order_year
	,count(*) as numor_ders
from 
	sales.orders
where 
	custid = 71
group by 
	empid
	,year(orderdate)
having 
	count(*) > 1
order by
	empid
	,order_year
;
go

-- you can also sort specifying the numbers associated to the expressions in the SELECT clause, but this is not the best practice:
select 
	empid
	,year(orderdate) as order_year
	,count(*) as numor_ders
from 
	sales.orders
where 
	custid = 71
group by 
	empid
	,year(orderdate)
having 
	count(*) > 1
order by
	1, 2
;
go

-- you can also sort by elements that are not specified in the SELECT clause
select
	empid
	,firstname
	,lastname
	,country
from
	hr.employees
order by
	hiredate
;
go

-- but if there is a DISTINCT clause, you are restricted in the ORDER BY clause to sort only foer elements listed in the SELECT clause
-- this will give you an error:
select distinct
	country
from
	hr.employees
order by
	empid
;
go

-- The TOP option
-- The TOP option
-- limit to 5 rows the output of this query:
select top 5
	orderid
	,orderdate
	,custid
	,empid
from
	sales.orders
order by 
	orderdate desc
;
go

-- top 1 percent of the total rows from the sales.orders table (830 rows)
select top 1 percent
	orderid
	,orderdate
	,custid
	,empid
from
	sales.orders
order by 
	orderdate desc
;
go --> 9 rows as result
-- note: 830 (rows) * 0.01 = 8.3 -> rounded up = 9
select ceiling(830 * 0.01) as top_1_percent
