use Test_C001
;
go

-- WINDOW FUNCTION
-- WINDOW FUNCTION

-- ripasso group by

-- 830 righe, sono tutti gli ordini che hanno fatto i customer
select custid
from sales.orders
;

-- 89 righe, sono i customer distinti che hanno fatto ordini
select distinct custid 
from sales.orders
;

-- allo stesso modo ottengo 89 righe (e' come se avessi fatto una distinct)
select custid
from sales.orders
group by custid
;

-- le group by si usano con le funzioni di aggregazione min() max() sum() count() avg()
-- in questo caso vedo per ogni customer il totale del freight
select custid, sum(freight) as SumFre
from sales.orders
group by custid
;

-- prendiamo come esempio la vista sales.ordervalues
select * from sales.ordervalues
;

-- la over clause (posticipata a una funzione di aggregazione o di ranking) espone un certo
-- set di righe a un calcolo (quello specificato nella funzione di aggregazione o ranking precedente).
-- Se le parentesi sono vuote espone l'intero campo al calcolo, quindi il valore totale per ogni riga del campo (830)
select 
	sum(val) over() as TotVal
	,custid
from sales.OrderValues
order by custid 
;

-- che in questo caso sarebbe come fare, solo che qui ho una riga sola 
select sum(val) as TotVal
from sales.OrderValues 
;

-- e' poco indicativo avere un campo che contiene per ogni riga il valore totale di tutti, senza partizionare quella somma
-- per ogni clienti. Quindi voglio sapere il valore totale di acquisto per ogni cliente. con una GROUP BY farei cosi (89 righe)
select 
	sum(val) as TotVal
	,custid
from sales.OrderValues 
group by custid
order by custid
;

-- con la OVER invece non devo raggruppare (avro' 830 righe infatti), per ogni riga di uno stesso customer
-- avro' il suo totale di val
select 
	sum(val) over (partition by custid) as TotVal
	,custid
from sales.OrderValues 
order by custid
;

-- con una DISTINCT e la OVER ottengo lo stesso identico codice della group by
select distinct
	sum(val) over (partition by custid) as TotVal
	,custid
from sales.OrderValues 
order by custid
;

--esempio di over partizionato e non partizionato
select 
	orderid
	,custid
	,val
	,sum(val) over (partition by custid) as TotValPart
	,sum(val) over() as TotalVal
from sales.OrderValues 
order by custid
;

-- esempio di calcolo. posso fare le percentuali, perche' ho il totale totale e il totale per cliente. Ricorda che il tipo di risultato nelle divisioni in sql 
-- dipendono anche dal data type. es. int/int = int, ma int/num = num. Sql prende il datatype piu' preciso per darci il risultato
select 
	orderid
	,custid
	,val
	,(val / sum(val) over (partition by custid)) * 100.0 as CustidValPct
	,sum(val) over (partition by custid) as TotValPart
	,(sum(val) over (partition by custid) / sum(val) over()) * 100.0 as CustidTotPct 
	,sum(val) over() as TotalVal
from sales.OrderValues 
order by custid
;

-- voglio controllare che i valori del campo CustidTotPct diano effettivamente 100 (perche' in percentuale, il tot deve dare 100%)
-- creo una tabella temporanea, su cui poi andro' a fare il calcolo
select 
	orderid
	,custid
	,val
	,(val / sum(val) over (partition by custid)) * 100.0 as CustidValPct
	,sum(val) over (partition by custid) as TotValPart
	,(sum(val) over (partition by custid) / sum(val) over()) * 100.0 as CustidTotPct 
	,sum(val) over() as TotalVal
into #t
from sales.OrderValues 
;

-- ora faccio il calcolo
select sum( distinct CustidTotPct) from #t --99.99 
;

-- window function con funzioni di ranking row_number(), rank(), dense_rank(), ntile()

-- funzioni di ranking, valutano il ranking sul campo che passo dentro la over() sotto la order by
-- nota differenze su riga 7 e 8
select	
	orderid
	,custid
	,val
	,row_number() over(order by val) as RowNumber
	,rank() over(order by val) as [Rank]
	,dense_rank() over(order by val) as DenseRank
from sales.OrderValues
;

-- mettendo due campi nell'order by gli do modo di valutare un secondo campo per fare il ranking
-- e quindi nel caso il primo fosse uguale va a vedere i valori del secondo
-- ora le righe 7 e 8 si comportano in modo diverso perche' il custid (secondo campo dell'order by)
-- gli da' modo di fare un ranking senza doppioni
select	
	orderid
	,custid
	,val
	,row_number() over(order by val, custid) as RowNumber
	,rank() over(order by val, custid) as [Rank]
	,dense_rank() over(order by val, custid) as DenseRank
from sales.OrderValues
;

-- ntile() function permette invece di suddividere il campo passato nella over(order by ) secondo il numero di classi
-- passato nella ntile() -> avro' quindi 279 classi perche'
select 830/279. -- circa 3, infatti:
;

select
	orderid
	,custid
	,val
	,ntile(279) over(order by custid) as RankClass
from
	sales.OrderValues
;

-- anche le funzioni di ranking supportano il partition by dentro la clausola over(). E' utile quando vogliamo
-- numerare un elemento che prima e' stato partizionato. Ad esempio se voglio numerare per custid gli ordini che hanno effettuato
select
	orderid
	,custid
	,val
	,row_number() over(partition by custid order by val) as row_numb_part
from sales.OrderValues
;

-- usare window function con funzione di comparazione -> lag() e lead()
-- lag() mi porta indietro di n righe (secondo argomento della funzione) secondo una certa selezione di righe 
-- (data dalla over()), mentre la lead() mi porta avanti

-- LAG()
select 
	year(orderdate) as orderyear
	,empid
	,count(distinct custid) as curryear
	,lag(count(distinct custid), 1) over(order by year(orderdate)) as prevyear
from
	sales.orders
group by year(orderdate), empid
having empid = 1
order by orderyear

-- LEAD()
select
	year(orderdate) as yearorder
	,empid
	,count(distinct custid) as curr
	,lead(count(distinct custid), 1) over(partition by empid order by year(orderdate)) as forw
from sales.orders
group by year(orderdate), empid

-- giorni tra un ordine ed il successivo
select custid, orderdate from sales.orders order by custid, orderdate;

with cteA
as (
	select
		custid
		,orderdate
		,lead(orderdate,1) over(partition by custid order by orderdate) as ordine_succ
	from sales.orders
	)
select
	custid
	,orderdate
	,ordine_succ
	,DATEDIFF(day, orderdate, ordine_succ) as gg_succ
from cteA

/*
NOTA: il percorso logico che SQL nel processare una query e'

		-FROM
		-WHERE
		-GROUP BY
		-HAVING
		-SELECT
			.OVER
			.DISTINCT
			.TOP
		-ORDER BY
*/
