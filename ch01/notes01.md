# Background to tSQL Querying and Programming

## Theoretical Background
SQL stands for *Structured Query Language*. It was designed to query and manage data in relational database management system (RDBMS). This type of database is based on two mathematical branches: **set theory** and **predicate logic**.
Unlike many programming languages, SQL requires you to specify *what* you want to get and not *how* to get it. The task of the RDBMS is to figure out the physical mechanics of processing your request.

SQL has several categories of statements:
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
The relational model is a semantic model for representing data and is based on set theory and predicate logic. The goal of the relational model is to enable consistent representation of data with minimal or no redundancy and without sacrificing completeness, and to define data integrity as part of the model. An RDBMS is supposed to implement the relational model and provide the means to store, manage, enforce the integrity of, and query data.

The common belief that the term *relational* stands for relationship between tables is incorrect. **Relational** actually concerns to the mathematical term *relation*. **Relation** is a representation of a set in set theory. In the relational model, a **relation** is a set of related information, with the implementation in the database being a table. When you design a data model for your database, you represent all data with relation (tables). You start by identifying propositions that you will need to represent in your database. A **proposition** is an assertion that must be true or false. For example the statement "customer Alessio Tugnoli was born on November 28, 1994 in Italy" is a proposition. If thi proposition is evaluated as true, it will manifest itself a s a row in the table of Customers. A false proposition simply won't manifest itself.

The next step is to formalize proposition. You do this by taking out the actual data and defining the structure: creating predicates out of propositions. The heading of a relation include a set of **attributes**. In the relational model attributes are unordered. An attribute is identify by an **attribute name** and a **domain name** (type). For example the heading of the Customer table might consist of the following attributes (attribute name - domain name): customerid - integer, firstname - character string, lastname - character string, birthdate - date, country - character string. A domain name is the possible/valid set of values for an attribute. For example the domain INT (integer) is the set of all inegers in the range -2,147,483,684 to 2,147,483,647. A domain is the simplest form of a predicate in our database because it restricts the attributes values that are allowed. For example, the database would not accept a proposition where an employee birthdate is November 45, 1994 or even a 'abcdef'.

### Missing Values
So far we have talked about two possible results of a logical predicate: true or false. So if a proposition is not true it must be false. 
In reality there is room for a three-valued evaluation of the logical predicate (in some cases even four), taking into account cases if something is unknown. For example a cell phone attribute of an Employee relation. Suppose that certain employee's phone number is missing. How do you represent this in a database? In a three-valued logic implementation, the cell phone attribute should allow a special mark for a missing value.
For some purists there were two different cases of missing values: missing but applicable and missing but not applicable. Missing but applicable is when we don't know the cell phone number but the employee got one. Missing but not applicable is when the employee doesn't have a cell phone at all.
SQL implements a three-valued predicate logic by supporting the NULL mark to signifythe generic concept of a missing value.

### Constraints
One of the greatest benefits of the relational model is having **data integrity**. Integrity is achieved through rules, or *constraints*, that are defined in the data model and enforced by the RDBMS. The simplest methods of enforcing integrity are the **attribute type** and its **NULLability** (wether it supports or doesn't support NULLs), which enforce domain integrity.
Other examples of constraints include **candidate keys** and **foreign keys**. A candidate key is a key defined on one or more attributes preventing **more then one occurrance** of the same tuple (row) in a relation. A predicate based on a candidate key can uniquely identify a row. You can define multiple candidate keys in a relation. One of the candidate keys is arbitrarily chosen as the **primary key**, and is used as the preferred way to identify a row. All other candidate keys are also known as **alternate keys**. A foreign key is defined on one or more attributes of a relation and references a candidate key in another relation. This constraint restricts the values in the **referencing relation’s foreign key attributes** to the values that appear in the **referenced relation’s candidate key attributes**. For example, only the values present in the department ID (primary key) attribute of a relation, can enter the department ID (foreign key) attribute of another relation.

## The Data Life Cycle
This section describes the different environments that data can reside in and the characteristics of both the data and the environment in each stage in the data life cycle.

### OnLine Transactional Processing - OLTP
Data is initially entered in an OLTP system. The focus of an OLTP is **data entry** (INSERT, UPDATE, DELETE) and not reporting. In a normalized environment each table represents a single entity and redundancy is at minimum. When you need to modify a fact you need to modify it in only one place. An OLTP environment is not suitable for reporting purposes because a normalized model usually involves many tables with complex relationships and poorly performing queries.

### Data Warehouse DW
DW is an environment designed for data **retrieval/reporting** purposes. For an entire organisation is called Data Warehouse; when serving a specific department is called Data Mart. The model ha intentional redundacy, which allows fewer tables and simpler relationships. The simplest design for a Data Warehouse is a **star schema** which includes several dimension tables and a fact table. Each dimension table represents a subject by which data is analyzed. For this reason each dimension is implemented as a single table with redundant data. For example a product dimension (DimProduct) could be implemented as a single table and not as three  normalized tables: Products, ProductSubCategories, ProductCategories. If you normalize a dimesion table, resulting in multiple tables representing the dimension you get what's known as *snow flake dimension*. A schema that contains snowflake dimension is known as **snow flake schema**.
The fact table holds the facts and measures such as quantity and value for each relevant combination of dimension keys.

The process that pulls data from source systems (OLTP and others), manipulates it, and loads it into the data warehouse is called **Extract Transform and Load**, or **ETL**. SQL Server provides a tool called *Microsoft SQL Server Integration Services (SSIS)* to handle ETL needs.

### OnLine Analytical Processing - OLAP
OnLine Analytical Processing (OLAP) systems support dynamic, online analysis of aggregated data. This type of work is not suitable for an OLTP or DW system. Online dynamic analysis of aggregated data usually involves frequent requests for different levels of aggregations, which
require slicing and dicing the data. Each such request might end up being very expensive if it needs to scan and aggregate large amounts of data, and chances are the response time will not be satisfactory.

To handle such needs you can **pre-calculate** different levels of aggregations:
  - Time dimension: yearly, monthly, daily
  - Product dimension: category, subcategory, product
  - ecc
When you pre-calculate aggregates, requests for aggregated data can be satisfied more quickly. Microsoft SQL Server Analysis Service allows to calculate and store different levels of aggregations from the relational data warehouse and storing them in optimized multidimensional structures known as **cubes**. **SSAS** is a separate service/engine from the SQL Server service.

### Data Mining
Data mining (**DM**) is the next step; instead of letting the user look for useful information in the sea of data, data mining models can do this for the user. That is, data mining algorithms helps to identify trends, figure out which products are purchased together, predict customer choices based on given parameters and so on.

## SQL Server Architectures
This section describes the different entities involved in SQL Server: instances, databases, schemas and database objects.

### SQL Server Instances
A SQL Server instance is an installation of a SQL Server database engine/service. You can install multiple instances of SQL Server on the same computer.
Each instance is completely independent of the others in terms of security, the data that it manages, and in all other respects. One of the instances on the computer must be named as *default instance*, while all others must be *'name' istance*. There are various reasons why you want to install multiple instances os SQL Server on the same computer:
- Save costs for the support department of the organisation to be able to test and reproduce errors that users face in production environment.
- Perform different versions of the product.
- ecc

### Databases
A database is a container of objects such as tables, views, stored procedure ecc. Each instance of SQL Server can contain multiple databases. When you install SQL Server, the setup program creates several **system databases** that hold system data and serve internal purposes:
- **master**: holds instance-wide metadata information, server configuration, information about all databases in the instance, and initialization information.
- **Resource**: holds all system objects. When you query metadata information in a database, this information appears to be local to the database but in practice it resides in the Resource database.
- **model**: is used as a template for new databases. Every new database that you create is initially created as a copy of model. So if you want certain database properties to be configured in a certain way in all new databases, you need
to create those objects and configure those properties in the model database.
- **tempdb**: where SQL Server stores temporary data. SQL Server allows you to create temporary tables for your own use, and the physical location of those temporary tables is tempdb. Note that this database is destroyed and recreated as a copy of the model every time you restart the instance of SQL Server. For this reason,
when I need to create objects for test purposes and I don’t want the objects to remain in the database, I usually create them in tempdb. I know that even if I forget to clear those objects, they will be automatically cleared after restart.
- **msdb**: is where a service called SQL Server Agent stores its data. SQL Server Agent is in charge of automation, which includes entities such as jobs, schedules, and alerts.

When creating a database you can define the *collation*: a property that will determine language support, case sensitivity, and sort order for character data in that database.

To run tSQL code against a database, a client application need to connect a SQL Server instance and be in the context of use of the relevant database.

The database is made of data and transaction log files. Each database must have at least one data file and at least one log file. The **data files** hold object data, the **log files** hold information that SQL Server needs to mantain transactions. SQL Server can write on multiple data files in parallel, but can only write to one log file at a time.
Data files are organized in logical groups called **filegroups**. The object data created (a table or an index..) will be spread across the files that belong to the target filegroup. A database must have at least one filegroup named **PRIMARY** containing the primary data file and the database's system catalog.

### Schemas and Objects
A database contains objects, but more precisly a database contains schemas and schemas contain objects. Schemas is a container of objects such as tables, views, stored procedures and others. You can control permissions at a schema level, granting a user SELECT permissions on a schema, allowing the user to query data from all objects in the schema. Schema is also a namespace: is used as a prefix to the object name.

### Defining Data Integrity
One of the greatest benefits in the relational model is that data integrity is an integral part of it.

## Primary Key Constraints
A primary key contraint enforces uniqueness of rows and also disallow NULLs in the constraint attributes. Each table can have only one primary key. With a primary key in place you can be assured that all rows of the table will be unique. When creating a primary key, SQL Server creates a unique index behind the scenes. A **unique index** is a mechanism to enforce uniqueness and speed up queries by avoiding unnecessary *full table scan*.

## Unique Constraints


## Foreign Key Constraints
Enforces referencial integrity. This constraint points to a set of candidate key (primary key or unique constraint) attributes in what's called the *referenced* table. 

## Check Constraints
Allows you to define a predicate that a row must meet to enter the table or to be modified. For example a check constraint that ensures that the salary column will support only positive values: salary > 0. An attempt to insert or update a row with a nonpositive salary value will be rejected by the RDBMS (hence the predicate evaluates the value to FALSE). The modification will be accepted when the predicate evaluates to either TRUE or UNKNOWN (hence salary NULL will be accepted).
When adding CHECK and FOREIGN KEY constraints, you can specify an option called WITH NOCHECK: telling the RDBMS that you want it to bypass constraint checking for existing data.

## Default Constraints
Is associated with a particular attribute. It is an expression that is used as the default value when an explicit value is not provided for that attribute whe you insert a row. The foreign key’s purpose is to restrict the domain of values allowed in the foreign key columns to those that exist in the referenced columns.





























