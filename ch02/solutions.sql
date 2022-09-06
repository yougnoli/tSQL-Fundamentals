-- 1
select 
	orderid
	,orderdate
	,custid
	,empid
from 
  	sales.orders
where 
  	year(orderdate) = 2021 and month(orderdate) = 6
;
go

-- 2
select
	orderid
	,orderdate
	,custid
	,empid
from
	sales.orders
where
	eomonth(orderdate) = orderdate
;
go

-- 3
select
	empid
	,firstname
	,lastname
from
	hr.Employees
where
	lastname like '%e%e%'
;
go

-- 4
select
	orderid
	,sum(qty * unitprice) as total_value
from
	sales.OrderDetails
group by
	orderid
having 
	sum(qty * unitprice) > 10000
;
go

-- 5
select top 3
	shipcountry
	,avg(freight) as avg_freight
from
	sales.orders
where
	year(orderdate) = 2021
group by 
	shipcountry
order by
	avg_freight desc
;
go

-- 6
select 
	custid
	,orderdate
	,orderid
	,row_number() over(partition by custid order by orderdate) as row_num
from
	sales.orders
order by 
	custid
;
go

-- 7
select
	empid
	,firstname
	,lastname
	,titleofcourtesy
	,case 
		when titleofcourtesy in ('Ms.', 'Mrs.') then 'Female'
		when titleofcourtesy = 'Mr.' then 'Male'
		else 'Unknown'
	end as gender
from
	hr.employees
;
go

-- 8
select
	custid
	,region
from
	sales.customers
order by
	case when region is null then 0 else 1 end desc, region
;
go
