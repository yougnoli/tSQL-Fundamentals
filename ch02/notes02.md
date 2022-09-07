# Single-Table Queries
This chapter introduces to the fundamentals of the SELECT statement, focusing on queries against a single table.

## Elements of the SELECT Statement
The purpose of a SELECT statement is to query tables, apply some logical manipulation, band return a result.
Before getting into details of each phase of the SELECT statement notice that in most programming languages the lines of code are processed in the orderthat they are written.
In SQL things are different. Even though the SELECT clause appears first in the query, it is logically processed almost at last. The clauses are logically processed in this order:
- FROM
- WHERE
- GROUP BY
- HAVING
- SELECT
- ORDER BY
Here is wat the query does in a readable manner following the logical processing:
- Queries the rows *from* a table;
- Filters only rows *where* a certain logical predicate is TRUE;
- *Groups* certain values;
- Filters only rows from the groups *having* a certain TRUE logical predicate;
- *Selects* (returns) only specified columns;
- *Orders* (sort) rows in a certain manner.
Unfortunately we cannot write quaries following the logical order. We have to start with the SELECT clause.

Terminate all statements with a semicolon because it is standard: it improves the code readability, and it is likely that SQL Server will require this in more cases 
in the future. Currently, when a semicolon is not required, adding one doesn’t interfere.

### The FROM Clause
Is the very first query clause that is logically processed. In this query you specify the name of the table you want to query.
To return all rows from a table with no special manipulation, all you need is a query with a FROM clause where you specify the table you want to query, and a SELECT clause where you specify the attributes you want to return. Although it might seem that the output is given in a sorted order, this is not guaranteed.

### The WHERE Clause
In the WHERE clause, you specify a predicate or logical expression to filter the rows returned by the FROM phase. Only rows for which the logical expression 
evaluates to TRUE are returned by the WHERE phase to the subsequent logical query processing phase.

Based on what you have in the filter expression, SQL Server evaluates the use of indexes to access the required data. By using indexes, SQL Server can sometimes get 
the required data with much less work compared to applying full table scans.

### The GROUP BY Clause
The GROUP BY phase allows you to arrange the rows returned by the previous logical query processing phase, in groups. The groups are created by the elements you specify in the GROUP BY clause. For example grouping by *empid* and *year(orderdate)* elements means that the GROUP BY clause produces a group for **each combination** of employeeID and orderdate year values that appears in the data returned by the WHERE phase. 
The WHERE phase returned 31 rows, within which there are 16 unique combinations of employee ID and order year values.

If the query involves grouping, all phases subsequent to the GROUP BY phase (including HAVING, SELECT, and ORDER BY) must operate on groups as opposed to operating on
individual rows. This implies that all expressions that you specify in clauses that are processed in subsequent phases to the GROUP BY phase are required to guarantee 
returning a scalar (single value) per group.

Because an aggregate function returns a single value per group, **elements that do not participate in the GROUP BY list are only allowed as inputs to an aggregate 
function** such as COUNT, SUM, AVG, MIN, or MAX.
- SUM(attribute): returns the sum of all values of that attribute in each group; 
- COUNT(*): returns the count of rows in each group.

Note that all aggregate functions ignore NULLs with one exception: COUNT(*).

### The HAVING Clause


### The SELECT Clause


### The ORDER BY Clause


### The TOP Option


### The OVER Clause



## Predicates and Operators



## CASE Expressions
