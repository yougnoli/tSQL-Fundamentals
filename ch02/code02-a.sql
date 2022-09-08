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

-- this query gives me the top 5 rows order by orderdate
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
-- if you want to see possible dates that come out of the top (5) still the same to the one on the top (5):
-- now I have 8 rows, but the top is 5
select top 5 with ties
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

-- The OVER Clause
-- The OVER Clause
-- exposing all rows to a calculation (thanks to the aggregate function SUM())
select
	orderid
	,custid
	,sum(val) over() as total_value
from	
	sales.OrderValues
;
go
-- exposing all rows to a calculation, partioned by a certain attribute. When the attribute changes, the calculation starts over.
select
	orderid
	,custid
	,sum(val) over() as total_value
	,sum(val) over(partition by custid) as total_value
from	
	sales.OrderValues
;
go
-- I can combine in a single row two OVER clauses:
select
	orderid
	,custid
	,sum(val) over(partition by custid) as total_value_per_custid
	,sum(val) over() as total_value
	,val / sum(val) over(partition by custid) * 100 as pct_custid
from	
	sales.OrderValues
;
go

-- ranking functions
-- remember: Windowed functions can only appear in the SELECT or ORDER BY clauses
select
	orderid
	,custid
	,val
	,row_number() over(order by val) as row_num
	,rank() over(order by val) as [rank]
	,dense_rank() over(order by val) as [dense_rank]
	,ntile(100) over(order by val) as [ntile]
from
	sales.OrderValues
-- where row_number() over(order by val) > 10 ERROR!!
order by val
;
go

--ranking functions also support a PARTITION BY clause in the OVER clause
select
	orderid
	,custid
	,val
	,row_number() over(partition by custid order by val) as row_num
	from
		sales.OrderValues
	order by
		custid,val
	;
	go

/*
■ FROM
■ WHERE
■ GROUP BY
■ HAVING
■ SELECT
	❏ OVER
	❏ DISTINCT
	❏ TOP
■ ORDER BY

Why it matters that the DISTINCT clause is processed after window calculations
that appear in the SELECT clause are processed, and not before?
*/
select 
	count(val) as num_of_rows
from 
	sales.OrderValues
;
go -- 830 rows 

select distinct		
	val
from 
	sales.OrderValues
;
go -- 795 disitnct val

select distinct
	val
	,row_number() over(order by val) as row_num
from 
	sales.OrderValues
;
go -- 830 rows => because the DISTINCT is processed after the ROW NUMBER which create unique rows to the set
/*
You can consider it a best practice not to specify both DISTINCT and ROW_NUMBER in the same SELECT clause as the DISTINCT
clause has no effect in such a case.
*/

-- In order to have distinct values with numeration:
select
	val
	,row_number() over(order by val) as row_num
from 
	sales.OrderValues
group by
	val
;
go -- 795 rows
