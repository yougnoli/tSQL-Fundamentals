/*
Gli indici servono per velocizzare le query. 
Il piano di esecuzione è il piano che salva SQL quando esegue una query, è riutilizzabile.
Il piano di esecuzione si basa sugli INDICI e sulle STATISTICHE.
Per restituirmi il risultato di una query SQL cerca il percorso migliore che gli conviene fare:
	- SCAN TABLE: parte dalla prima riga e arriva fino all'ultima, legge tutta la tabella (non sono presenti indici: HEAP)
	- SEEK TABLE: quando è presente un indice e decide di utilizzarlo

Alla creaizone dell'indice SQL crea una STRUTTURA AD ALBERO dove il livello più in basso è il livello FOGLIA o Data Pages,
poi c'è un LIVELLO INTERMEDIO,
poi c'è il ROOT.

						***********************************
						*                                 *
						*         CLUSTERED INDEX         *
						*                                 *
						***********************************
Esempio: la rubrica telefonica, dove ogni lettera è una sezione dove ci sono i nomi e il numero di telefono corrispondente
Con questo indice i dati ordinati sono fisicamente storati dentro al livello FOGLIA.
Quando un campo viene creato con il constraint PRIMARY KEY viene anche automaticamente creato un indice CLUSTERED.
Questo indice ordina i dati là dove sono storati (livello foglia). 
Può esserci solo un indice CLUSTERED per tabella, 
ma è possibile che quell'unico indice CLUSTERED sia definito su più campi (COMPOSITE CLUSTERED INDEX).


						***********************************
						*                                 *
						*	NON CLUSTERED INDEX       *
						*                                 *
						***********************************
Esempio: un libro, dove l'indice del libro è dove ci sono le informazioni per andare alle pagine dei capitoli.
Con questo indice nel livello FOGLIA è presente il puntatore per la posizione dei dati ordinati.
Possono esserci più indici NONCLUSTERED nella stessa tabella.


DIFFERENZE:
	1. Indice CLUSTERED ce n'è uno solo per tabella
	2. Indice CLUSTERED è più veloce perchè riporta direttamente ai dati nel livello foglia
	3. Indice CLUSTERED determina l'ordine delle righe della tabella quindi non richiede spazio addizionale
	   (Indice NONCLUSTERED invece è separato da dove vengono storati i dati, quindi richiede più spazio di storage).


*/

create database test;

create table dbo.employees (
	id int primary key identity(1,1)
	,[name] varchar(50)
	,[email] varchar(50)
	,[department] varchar(50)
);

set nocount on;

declare @counter int = 1

while (@counter <= 100000)
begin
	declare @name varchar(50) = 'ABC ' + rtrim(@counter)
	declare @email varchar(50) = 'abc' + rtrim(@counter) + '@test.com'
	declare @dept varchar(50) = 'dept ' + rtrim(@counter)

	insert into dbo.employees values (@name, @email, @dept)

	set @counter = @counter + 1
end;

-- check per indici:
exec sp_helpindex employees;

-- con l'EXECUTION PLAN e le STATISTICS IO attivate vedo il piano di esecuzione (scan o seek della tabella)
-- e vedo le pagine lette (logical reads)
set statistics io on;
-- query sul campo [id] dove c'è l'indice clustered
-- CLUSTERED INDEX SEEK -> numero di righe lette 1, numero di pagine lette: 3
select * from employees where id = 93200;
-- query sul campo [name] dove non c'è nessun indice
-- CLUSTERED INDEX SCAN -> numero di righe lette 100.000, numero di pagine lette: 705
select * from employees where [name] = 'ABC 93200';

-- Necessità di creare un indice NONCLUSTERED sul campo [name]:
create nonclustered index IX_employees_name
on dbo.employees ([name]);
-- check per indici:
exec sp_helpindex employees;

-- query di nuovo sul campo [name] dove non c'è indice NONCLUSTERED
-- INDEX SEEK (NONCLUSTERED) + LOOKUP (CLUSTERED) -> numero di righe lette 1, numero di pagine lette: 6
select * from employees where [name] = 'ABC 93200';


-- esempio di un COMPOSITE CLUSTERED INDEX (devo eliminare prima il precedente CLUSTERED INDEX):
create clustered index IX_employees_id_name_clustered
on dbo.employees ([id] asc, [name] asc);
-- INDEX SEEK (NONCLUSTERED) + LOOKUP (CLUSTERED) -> numero di righe lette 1, numero di pagine lette: 6
select * from employees where [name] = 'ABC 93200';
-- CLUSTERED INDEX SEEK-> numero di righe lette 1, numero di pagine lette: 3
select * from employees where id = 93200;

-- drop table dbo.employees
-- drop database test
