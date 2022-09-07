
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

/*
all attributes or expressions in the select clause that are not aggregate functions must go into the group by
*/
-- this will give me an error (freight: no calculation on him, not in the group by clause)
select
	empid
	,year(orderdate) as order_year
	,freight
from
	sales.orders
where
	custid = 71
group by 
	empid
	,year(orderdate)
;
go







