-- ESERCIZIO NUMERO
-- CONSEGNA
-- TABELLA DA USARE
-- RIGHE SOLUZIONE

-- esercizio 1
-- utilizzando window function mostrare il numero degli ordini per ciascun cliente in ordinde decrescente
-- sales.orders
-- 89 rows
 
-- esercizio 2
-- mostrare numero degli ordini per ciascun cliente in ordine decrescente
-- sales.orders
-- 89 rows

-- esercizio 3
-- mostrare tutti gli orderid, orderdate, custid e empid di novembre del 2015
-- sales.orders
-- 30 rows

-- esercizio 4
-- mostrare tutti gli impiegati che hanno nel loro firstname 2 volte la lettera a
-- hr.employees
-- 3 rows

-- esercizio 5 
-- mostrare la media del freight per ogni anno, per gli ordini che provengono dagli usa, francia, brasile e italia
-- sales.orders
-- 12 rows

-- esercizio 6
-- mostrare la differenza di giorni media tra data dell'ordine e data di spedizione per ogni paese. Ordinare per la media decrescnte
-- sales.orders
-- 21 rows

-- esercizio 7
-- mostrare tutti gli orderid, custid, shippeddate, empid degli ordini spediti dopo il 1 giugno 2015 (compreso). Ordina per data crescente
-- sales.orders
-- 512 rows

-- esercizio 8
-- mostrare custid e companyname e in un nuovo campo mostrare con un 'Gold' se il cliente ha effettuato più di 20 ordini,
-- 'Silver' se ne ha fatti tra 10 e 20, 'Bronze' meno di 10. Ordina in modo tale da vedere prima tutti i gold, poi i silver e poi i bronze
-- sales.customers, sales.orders
-- 89 rows

-- esercizio 9
-- mostrare il custid e il companyname dei clienti che hanno un freight totale nel 2016 maggiore di 300 (compreso)
-- sales.orders, sales.customers
-- 21 rows

-- esercizio 10
-- query che calcola numero di righe incrementale ordinati per orderdate e orderid. Campi da mostrare:
-- orderid, orderdate, custid, empid, campo che conta le righe
-- sales.orders
-- 830 rows

-- esercizio 11
-- con una cte prendi dalla query precendente solo i record con i row_num che vanno dalla 11 alla 20
-- sales.orders, cte
-- 10 rows

-- esercizio 12
-- mostra la quantità TOTALE ordinata per ogni prodotto, Campi da mostrare productid e il tot della quantità. Ordina per tot quantità decrescente
-- sales.ordersdetails
-- 77

-- esercizio 13
-- crea una vista che riporta la quantità totale per ogni impiegato, per ogni anno. Mostra la vista ordinandola prima per anno crescente e poi per quantità decrescente
-- sales.ordersdetails, sales.orders
-- 27 rows

-- esercizio 14
-- mostra SOLO i paesi (country) dove ci sono i customers, ma non impiegati (empid) -> usa una subquery
-- sales.customer, hr.employees
-- 19 rows

-- esercizio 15
-- mostra per ogni customer, il suo primo ordine e il suo ultimo ordine. inoltre mostra anche la differenza di giorni tra queste due date. 
-- sales.orders
-- 89 rows

-- esercizio 16
-- mostra per ogni customer, il suo primo ordine e il suo ultimo ordine. questa volta utilizza saggiamente la row_number()
-- sales.orders, cte
-- 177 rows

-- esercizio 17
-- dall'esercizio 16 aggiungi anche la somma del freight per quei due giorni
-- sales.orders
-- 177 rows

-- esercizio 18
-- crea una table function che prenda come paramentro l'ID del supplier e il NUMERO di prodotti da mostrare -> dbo.tf_topProducts(5, 2) -> 	productid|productname|unitprice
-- production.products

-- esercizio 19
-- con la table function appena creata, mostra per ogni supplier i suoi 2 prodotti più costosi -> companyname|productid|productname|unitprice
-- dbo.tf_topProducts, production.suppliers
-- 55 rows

-- esercizio 20
-- mostra la stringa '! ITINIF IZICRESE' al contrario, con una funzione adeguata -> cercala su internet!
-- 1 row
