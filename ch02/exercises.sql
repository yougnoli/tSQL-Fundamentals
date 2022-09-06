-- 1
-- Return orders placed in June 2021
-- Tables involved: TSQLV6 database, sales.orders table
-- Rows affected: 30

-- 2
-- Return orders placed on the last day of the month
-- Tables involved: TSQLV6 database, sales.orders table
-- Rows affected: 26

-- 3
-- Return employees with last name containing the letter 'e' twice or more
-- Tables involved: TSQLV6 database, hr.employees table
-- Rows affected: 2

-- 4
-- Return orders with total value (quantity * unitprice) greater than 10,000, sorted by total value
-- Tables involved: TSQLV6 database, sales.orderdetails table
-- Rows affected: 14

-- 5
-- Return the three ship countries with the highest average freight in 2021.
-- Tables involved: sales.orders table. 
-- Rows affected: 3

-- 6
-- Calculate row numbers for orders based on order date ordering (using order ID as tiebreaker) for each customer separately.
-- Tables involved: sales.orders table. 
-- Rows affected: 830

-- 7
-- Figure out the SELECT statement that returns for each employee the gender based on the title of courtesy. For ‘Ms.’ and ‘Mrs.’ return ‘Female’; for ‘Mr.’ return ‘Male’; and in all other cases (for example, ‘Dr.’) return ‘Unknown’.
-- Tables involved: hr.employees table. 
-- Rows affected: 9

-- 8
-- Return for each customer the customer ID and region. Sort the rows in the output by region, having NULLs sort last (after non-NULL values). Note that the default sort behavior of NULLs in T-SQL is to sort fi rst (before non-NULL values).
-- Tables involved: sales.customers table. 
-- Rows affected: 91
