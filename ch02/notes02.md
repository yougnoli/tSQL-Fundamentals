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
With the HAVING clause you can specify a predicate/logical expression to **filter groups** as opposed to filtering individual rows, which happens in the WHERE clause. Groups for which the logical expression evaluates FALSE or UNKNOWN are filtered out. 
In the HAVING clause (who take the rows after being grouped from the GROUP BY) you can **refer to aggregate functions** in the logical expression.

### The SELECT Clause
Is where you specify the attributes (columns) that you want to return in the result table of the query.
You can optionally assign your own name to the target attribute by using the AS clause -> <expression> AS <alias>.

Remember that the SELECT clause is processed after the FROM, WHERE, GROUP BY, and HAVING clauses. This means that **aliases assigned to expressions in the SELECT clause do not exist as far as clauses that are processed before the SELECT clause are concerned**.
 
If the tables you query have keys and qualify as sets, a SELECT query against the tables can still return a result with duplicate rows. The term result set is often used to describe the output of a SELECT query, but a result set doesn’t necessarily qualify as a set in the mathematical sense. SQL provides the means to guarantee uniqueness in the result of a SELECT statement in the form of a DISTINCT clause that removes duplicate rows.
 
SQL supports the use of an asterisk (*) in the SELECT list to request all attributes from the queried tables instead of listing them explicitly, but this is bad programming practice (in most cases). It is recommended that you explicitly specify the list of attributes that you need even if you need all of the attributes from the queried table.
 
Note: within the SELECT clause you are still not allowed to refer to a column alias that was created in the same SELECT clause.

### The ORDER BY Clause
The ORDER BY clause allows you to sort the rows in the output for presentation purposes. In terms of logical query processing, ORDER BY is the very last clause to be processed.

One of the most important points to understand about SQL is that a table has no guaranteed order, because a table is supposed to represent a set (or multiset if it has duplicates), and a set has no order. 

Note: the ORDER BY phase is in fact the only phase in which you can refer to column aliases created in the SELECT phase, because it is the only phase that is processed after the SELECT phase. 

If you want sorting in descendin order you have to specify DESC after the expression, for ascending order (which is default) you can eventually specify ASC.  
 
### The TOP Option
Allows you to limit the number of rows that your query returns. In terms of logical processing the TOP option is processed as part of the SELECT phase, right after the DISTINCT clause (if one exists). 

You can use the TOP option with the PERCENT *keyword*, in which case SQL Server calculates the number of rows to return based on the percentage of the number passed after the TOP and before the PERCENTAGE, rounded up.

In case of ties, SQL Server chooses rows based on whichever row it physically happens to access first. To have all the rows that have the same values (for example the same date), in the presence of a top that could cut some out, it is possible to add the WITH TIES option which shows all the same values even if the top should have limit the return.

### The OVER Clause
The OVER clause exposes a window of rows to certain kinds of calculations. Aggregate and ranking functions, for example, are the types of calculations that support the OVER clause. Because the OVER clause exposes a window of rows to those functions, they are known as window functions. An aggregate window function operates against a set of values in a window of rows that you expose to it using the OVER clause, and not in the context of a GROUP BY query. Therefore, you don’t have to group the data.
An OVER clause with empty parentheses exposes all rows to the calculation. Note that the OVER clause is allowed only in the SELECT and ORDER BY phases. If you want to restrict or partition the rows, you can use the PARTITION BY clause inside the OVER clause. In this way you can calculate on portions of the set, without having to group and always returning the same initial number of rows.

The OVER clause is also supported with four **ranking functions**:
 - ROW_NUMBER: assigns incrementing sequential integers to the rows in the result set of a query, based on logical order that is specifi ed in the ORDER BY subclause of the OVER clause. It must produce **unique values** even when there are ties in the ordering values.
 - RANK: produce the **same** ranking value in all rows that have the same logical ordering value. It resumes the count by skipping the number that did not count.
 - DENSE_RANK: produce the **same** ranking value in all rows that have the same logical ordering value. It resumes the count from the number it had left.
 - NTILE: allows you to associate the rows in the result with tiles (equally sized groups of rows) by assigning a tile number to each row. You specify as input to the function how many tiles you are after, and in the OVER clause you specify the logical ordering.
 
To put it all together, the following list presents the logical order in which all clauses discussed so far are processed:
 - FROM
 - WHERE
 - GROUP BY
 - HAVING
 - SELECT
   - OVER
   - DISTINCT
   - TOP
 - ORDER BY
 
## Predicates and Operators



## CASE Expressions
