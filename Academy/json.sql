-- JSON 
-- JSON 

-- cos'è un file json
/*

differenza tra un dato strutturato (-> condividono gli stessi attributi) 
e un dato semistrutturato (-> che possono non condividere gli stessi attributi) => file JSON
Esistono anche i dati non strutturati cioè dati che non possono essere strutturati (-> file video, audio, immagini)


Un file CSV è un tipo di file molto comune -> comma separated value. 
Ma ci sono delle problematiche per questi tipi di file, perchè non c'è uno STANDARD:
	-gestione delle stringhe
	-gestione del separatore
	-gestire il numero di campi
	-gestire il null o il blank
	-gestire se c'è un header oppure no

NON è quindi adatto o consigliato per i BIG DATA.

Il file JSON invece si:
	-è un formato molto leggero, semplice, chiaro

Regole del file json:
	-inizia e finisce con le {}
	-dentro ci sono COPPIE di chiave:valore -> chiave è separata dal valore dai :
	-le chiavi sono sempre scritte con i "". Il valore se è un testo ha i "" -> { "nome":"Alessio" }
	-le coppie chiave:valore sono separate dalla , ->  { "nome":"Alessio", "peso":80 }
	-per più valori contiene gli ARRAY -> [] -> { "nome":"Alessio", "peso":80, "gatti":["Spillo", "Saetta"] }
	-posso annidare json dentro json -> il json sarà il valore di una chiave -> {"amici":{"nome":"Eugenio","eta":30}}
	-posso annidare un array dentro un una chiave -> {"amici":[
																{"nome":"Eugenio","eta":30}, {"nome":"Piero","eta":28}
															  ]
													 }
	-posso fare anche un array di json e mettere tutto il nostro json dentro un array -> [{........}]
	-la notazione json è case sensitive

Esistono dei programmi online che formattano i json, ma anche il notepad++ (devono esserci installati i plugin di json viewer e formatter)
Le jsonfunction che vedremo sono specifiche di tSQL quindi di SQL Server

In SQL Server non esiste il datatype json -> lo prende in format testo -> usa gli apicini '{.....}'

*/

declare @j as varchar(max) = '{ 
									"nome":"Alessio", 
									"peso":80, 
									"gatti":["Spillo", "Saetta"],
							        "amici":[
												{"nome":"Eugenio","eta":30}, 
												{"nome":"Piero","eta":28}
											] 
						      }'
select isjson(@j)

-- come interrogare un file json:
-- JSON FUNCTIONS
-- JSON FUNCTIONS

-- json_value() -> è una funzione scalare
-- estrae un valore scalare da una stringa di json -> (espressione, percorso) -> nel percorso c'è il $ e il nome della chiave che mi interessa
declare @j as varchar(max) = '{ 
									"nome":"Alessio", 
									"peso":80,
									"moto":{
											"tipo":"RX10"
											},
									"gatti":["Spillo", "Saetta"],
							        "amici":[
												{"nome":"Eugenio","eta":30}, 
												{"nome":"Piero","eta":28}
											] 
						      }'
select
	json_value(@j, '$.nome') as nome
	,json_value(@j, '$.peso') as peso
	,json_value(@j, '$.gatti') as gatti --> mi dà un NULL perchè come valore c'è un oggetto complesso (array) => devo entrare nell'array
	,json_value(@j, '$.moto') as moto --> mi dà un NULL perchè come valore c'è un oggetto complesso (json) => devo navigare la gerarchia
	,json_value(@j, '$.gatti[0]') as gatto1 --> entrato nel primo elemento dell'array
	,json_value(@j, '$.gatti[1]') as gatto2 --> entrato nel secondo elemento dell'array
	,json_value(@j, '$.moto.tipo') as tipo_moto --> navigato la gerarchia


-- domanda: quale è l'età dell'amico che si chiama Piero?
declare @j as varchar(max) = '{ 
									"nome":"Alessio", 
									"peso":80,
									"moto":{
											"tipo":"RX10"
											},
									"gatti":["Spillo", "Saetta"],
							        "amici":[
												{"nome":"Eugenio","eta":30}, 
												{"nome":"Piero","eta":28}
											] 
						      }'
select 
	json_value(@j, '$.amici[1].eta') as eta_piero


-- json_query -> è una funzione scalare
-- restituisce non il valore singolo, ma l'intero valore -> che può essere un'altro json o un array (un oggetto complesso)
declare @j as varchar(max) = '{ 
									"nome":"Alessio", 
									"peso":80,
									"moto":{
											"tipo":"RX10"
											},
									"gatti":["Spillo", "Saetta"],
							        "amici":[
												{"nome":"Eugenio","eta":30}, 
												{"nome":"Piero","eta":28}
											] 
						      }'
select 
	JSON_QUERY(@j, '$.moto') as moto
	,JSON_QUERY(@j, '$.gatti') as gatti
	,JSON_QUERY(@j, '$.amici') as amici


-- creo una tabella dove ci metto dentro il json, in questo modo posso interrogarlo più comodamente,
-- senza tutte le volte dover specificare la variabile con il declare:
create table j (
	id		int				identity(1,1)
	,j		nvarchar(max)
)

-- voglio inserire la stringa di json creata prima:
declare @j as varchar(max) = '{ 
									"nome":"Alessio", 
									"peso":80,
									"moto":{
											"tipo":"RX10"
											},
									"gatti":["Spillo", "Saetta"],
							        "amici":[
												{"nome":"Eugenio","eta":30}, 
												{"nome":"Piero","eta":28}
											] 
						      }'
insert into j values 
(@j)

-- check:
select 
	json_value(j, '$.nome') as nome
	,json_query(j, '$.gatti') as gatti
from j


--openjson()
--openjson()

--openjson() -> non è una funzione scalare, ma una TABLE FUNCTION, va gestita come se fosse una tabella (va nella FROM)
--Se la funzione OPENJSON() riceve in input un json restituisce un record per ogni coppia chiave valore.
declare @j as varchar(max) = '{ 
									"nome":"Alessio", 
									"peso":80,
									"moto":{
											"tipo":"RX10"
											},
									"gatti":["Spillo", "Saetta"],
							        "amici":[
												{"nome":"Eugenio","eta":30}, 
												{"nome":"Piero","eta":28}
											] 
						      }'

select *
from 
	openjson(@j)  --> restituisce una riga per ogni coppia chiave:valore => sono 5 righe perche abbiamo 5 chiavi (nome, peso, moto, gatti, amici)

-- NOTA: ci pensa lui a srotolarcelo, è l'apriscatole del nostro file json.

-- Voglio applicare la table function openjson alla tabella j che ho creato prima:
-- la tabella j ha un solo record, e riesco a srotolare tutto il contenuto del json dentro quella tabella
select 
	*
from 
	j as a
	cross apply
	openjson(a.j) as b

--Se la funzione OPENJSON() riceve in input un array, restituisce n righe per gli n elementi dell'array
declare @j nvarchar(max) ='[{"alfa", "bravo"}]'{"codice":

selec}t *
from 
	openjson(@j); -- 2 righe perchè dentro all'array ci sono 2 elementi

-- ora voglio farlo con un array di json:
declare @j nvarchar(max) ='[
								{"codice":"alfa", "pezzi":1}, 
								{"codice":"bravo", "pezzi":2}
							]'

select *
from 
	openjson(@j); --> ancora 2 righe perche dentro al'array ci sono elementi (che sono 2 json) 
;


declare @j nvarchar(max) ='[
								{"codice":"alfa", "pezzi":1}, 
								{"codice":"bravo", "pezzi":2}
							]'
select
	*
from	
	openjson(@j) as a	--> queste sono le 2 righe del campo value che sono i 2 json
	cross apply
	openjson(a.[value])		--> vado a richiamare i 2 json del campo value


-- ultimo dettaglio: voglio orizzontalizzare il set che mi ha restituito.
-- la openjson accetta lo statement WITH e dopo descrivo la struttura del set che voglio in uscita

declare @j nvarchar(max) ='[
								{"codice":"alfa", "pezzi":1}, 
								{"codice":"bravo", "pezzi":2}
							]'
select
	*
from	
	openjson(@j) as a
	cross apply
	openjson(a.[value])	

	with (
			codice		varchar(20) '$.codice'	
			,valore		int			'$.pezzi'
		)


-- lavoro sul json iniziale inserendolo in una tabella temporanea:
create table #j (
	id		int				identity(1,1)
	,j		nvarchar(max)
)

insert into #j values
(
	'[
		{ "nome":"Alessio", 
			"peso":80,
			"moto":{
					"tipo":"RX10"
					},
			"gatti":["Spillo", "Saetta"],
			"amici":[
						{"nome":"Eugenio","eta":30}, 
						{"nome":"Piero","eta":28}
					] 
			}
		]'
	
	)

-- check:
select * from #j
-- è un json?
select ISJSON(j) from #j


-- srotoliamolo con la openjson()
select
	*
from 
	#j as a
	cross apply
	openjson(j) as b		--> 1 riga sola perchè dentro all'array ho il mio unico e intero json


select
	*
from 
	#j as a
	cross apply
	openjson(j) as b
	cross apply
	openjson(b.[value]) as c   --> spacchetto ulteriormente il json dentro l'array 
								-- questo json ha 5 coppie chiavi valore, quindi mi darà 5 righe


-- voglio i nomi e l'età degli amici:
select
	c.*
from 
	#j as a
	cross apply
	openjson(j) as b
	cross apply
	openjson(b.[value]) as c
where c.[key] = 'amici'

-->

select
	*
from 
	#j as a
	cross apply
	openjson(j) as b
	cross apply
	openjson(b.[value]) as c
	cross apply
	openjson(c.[value]) as d  --> ho rifatto cross apply e ho 2 righe perchè dentro quell'array ho 2 elementi
where c.[key] = 'amici'

-->

select
	*
from 
	#j as a
	cross apply
	openjson(j) as b
	cross apply
	openjson(b.[value]) as c
	cross apply
	openjson(c.[value]) as d
	cross apply
	openjson(d.[value]) as e
where c.[key] = 'amici'

--> vado a prendermi solo quello che esce dalla e 

select
	e.*
from 
	#j as a
	cross apply
	openjson(j) as b
	cross apply
	openjson(b.[value]) as c
	cross apply
	openjson(c.[value]) as d
	cross apply
	openjson(d.[value]) 
		with (
				nome varchar(20) '$.nome'
				,età int		 '$.eta'
			) as e
where c.[key] = 'amici'


-- json_modify()
-- json_modify()

select
	j
	,json_modify(j,'$.nome', 'Alessandro')	as [update]
	,json_modify(j, '$.citta', 'Bologna' )	as [insert]
	,json_modify(j,'$.moto', null)	as [delete]
from dbo.j


-- caricamento file json dal file che si trova in C:\Temp\ModelliAuto.txt

-- punto di partenza:
SELECT 
	*
FROM 
	OPENROWSET (BULK 'C:\Temp\ModelliAuto.txt', SINGLE_NCLOB) as a

-- vado a spacchettare questo array
SELECT 
	b.*
FROM 
	OPENROWSET (BULK 'C:\Temp\ModelliAuto.txt', SINGLE_NCLOB) as a --> questo è l'array
	CROSS APPLY 
	OPENJSON(a.BulkColumn) as b --> con questo avremo ogni riga per elemento dell'array (che sono 19,772 json)

-- vado a prendermi anno, produttore e modello -> uso le json functions, in particolare json_value()
SELECT 
	json_value(b.[value], '$.year') as anno
	,json_value(b.[value], '$.make') as produttore
	,json_value(b.[value], '$.model') as modello
FROM 
	OPENROWSET (BULK 'C:\Temp\ModelliAuto.txt', SINGLE_NCLOB) as a
	CROSS APPLY 
	OPENJSON(a.BulkColumn) as b

-- oppure avrei potuto fare:
SELECT 
	c.*
FROM 
	OPENROWSET (BULK 'C:\Temp\ModelliAuto.txt', SINGLE_NCLOB) as a
	CROSS APPLY 
	OPENJSON(a.BulkColumn) as b
	cross apply
	openjson(b.[value]) 
		with (
				anno			int				'$.year'
				,produttore		varchar(30)		'$.make'
				,modello		varchar(20)		'$.model'

		) as c

/*
esercizio:
	-creare tabella con i campi: id|anno|produttore|modello
	-inserire in una tabella quello che esce dalla query che punta al file .txt
*/

-- creo una tabella con campo id e un generico campo j senza i consueti campi anno|produttore|modello
create table modelliAuto (
	id			int			identity(1,1)
	,j			nvarchar(max)
)

-- inserisco dentro la tabella tutti i json dell'array
insert into dbo.modelliAuto 
	select b.[value]
	from
		openrowset (bulk 'C:\Temp\ModelliAuto.txt', single_nclob) as a
		cross apply
		openjson(BulkColumn) as b


-- vantaggio: non ho creato una struttura rigida per ospitare quel json ->  
-- ogni volta vado a prendermi quello che mi serve con le json functions

select
	JSON_VALUE(j, '$.year') as anno
	,JSON_VALUE(j, '$.make') as produttore
	,JSON_VALUE(j, '$.model') as modello
from
	dbo.modelliAuto

-- mi entrano nuovi dati, ma adesso i dati che arrivano hanno delle info aggiuntive che prima non c'erano!! es -> "Euro":5
-- se avessi costruito la tabella dbo.modelliAuto con esattamente il numero dei campi iniziale
-- ora sarei nella merda. Nel modo che ho infatto invece con un unico campo J mi permette di fregarmene
-- nel caso entrassero nuove coppie di chiavi valore nel json.

'{"year":2001,"make":"ARCTIC CAT","model":"ZR 440 SNO PRO","Euro":5}'
'{"year":2001,"make":"ARCTIC CAT","model":"Z 370 ES","Euro":5}'
-- inserisco i nuovi json

insert into dbo.modelliAuto values
	('{"year":2001,"make":"ARCTIC CAT","model":"ZR 440 SNO PRO","Euro":5}')
	,('{"year":2001,"make":"ARCTIC CAT","model":"Z 370 ES","Euro":5}')

-- grazie a un unico campo che accetta tutti i json, se entrano nuovi json con nuovi chiave:valore
-- sono parato
select
	JSON_VALUE(j, '$.year') as anno
	,JSON_VALUE(j, '$.make') as produttore
	,JSON_VALUE(j, '$.model') as modello
	,JSON_VALUE(j, '$.Euro') as euro
from
	dbo.modelliAuto
where JSON_VALUE(j, '$.Euro') is not null

-- NOTA: se nelle tabelle posso creare i campi calcolati, allora posso modificare la mia tabella
-- e aggiungere i campi che voglio:

alter table dbo.modelliAuto
	add Anno as JSON_VALUE(j, '$.year')
	,Produttore as JSON_VALUE(j, '$.make') 
	,Modello as JSON_VALUE(j, '$.model') 
	,Euro as JSON_VALUE(j, '$.Euro') 

-- check:
select * from dbo.modelliAuto
