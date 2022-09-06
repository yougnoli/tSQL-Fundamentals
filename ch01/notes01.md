# Background to tSQL Querying and Programming

## Theoretical Background
SQL stands for *Structured Query Language*. It was designed to query and manage data in relational database management system (RDBMS). This type of database is based on two mathematical branches: **set theory** and **predicate logic**.
Unlike many programming languages, SQL requires you to specify *what* you want to get and not *how* to get it. The task of the RDBMS is to figure out the physical mechanics of processing your request.

#### SQL has several categories..
..of statements:
- **DDL** (Data Definition Language) -> object definition (CREATE, ALTER, DROP)
- **DML** (Data Manipulation Language) -> querying and modify data (SELECT, INSERT, UPDATE, DELETE, MERGE)
- **DCL** (Data Control Langauge) -> deals with permissions (GRANT, REVOKE)

### Set Theory
*A set is any collection of definite, distinct objects of our perception or our thought considered as a whole. The objects are considered the elements or members of the set.*
A set should be considered as single entity. We focus on the collection of objects as opposed to the individual objects that make up the collection. For example, the Employees table should be considered as the set of employees as a whole and not as the individual employees. The world *distinct* means that every element of a set must be unique: tables in database can enforce their uniqueness of rows by defining a key constarint. Without a key you won't be able to uniquely identify rows and the table won't be qualified as a set (rather, would be a *multiset* or *bag*).
The **order** in which set elements are listed is not important. The formal notation for listing set elements is with curly brackets: {a, b, c}. Because order is not relevant in sets, the same set can be expressed as {b, a, c} or {c, a, b}. The elements of a set are described by their **attributes** not by the order of elements. Having unique attribute names enforces this requirement (irrelevance of order). 

### Predicate Logic
A predicate is an expression or a property is either true or false. In the relational model, predicates are used to mantain the logical **integrity** of the data and define its **structure**. One example of a predicate used to enforce integrity is a constraint defined in a table of Employees that allows only employees with a salary grater than 0 in the table. The predicate "salary grater than 0" -> salary > 0. You can use also predicates to filter data to define **subsets**. For example, if you need to query the Employee table and return only the rows for employess from the sales department, you would use the predicate: "daprtment equals sales" -> department = 'sales'.
In set theory you can use predicates to define sets. This is useful because to return certain elements from a set I don't need to write the elements I need, just the right predicate that allows me to retrieve those elements. 

### Relational Model
