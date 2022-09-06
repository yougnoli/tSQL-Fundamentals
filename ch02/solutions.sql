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
