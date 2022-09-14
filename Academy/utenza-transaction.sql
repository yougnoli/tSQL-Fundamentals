/*

CREAZIONE UTENZA

	-LOGIN: è l'autenticazione. Quando creo una login sto creando qualcuno che prova ad entrare.
	-USER: è mappato nella login e ha una certa autorizzazione. => diritto di fare qualcosa.

Il database da utilizzare è il db USER -> dove creiamo lo USER
Il database MASTER è il database che contiene le login -> dove creiamo la LOGIN (ma qua creeremo anche la USER, perchè ci è più comodo:
																				 in questo modo sono sicuro di essere connesso all'intera istanza dove
																				 ci sono tutti i databases.)
Poi a questo utente dovremo dargli i diritti per fare determinate cose.

*/

-- creo una SQL login -> mi posiziono sul master:
create login Pippo with password = 'AlfaBravo22$'	--> questa non può fare assolutamente nulla! Neanche connettersi

-- creo USER (nota: il nome dello user può essere diverso dalla login => sono 2 oggetti diversi) -> mi posiziono sul master:
create user Pippo from login Pippo

-- mi posiziono sul db Test
-- creo USER (nota: il nome dello user può essere diverso dalla login => sono 2 oggetti diversi):
create user Pippo from login Pippo

/*
Ora l'utenza Pippo avrà accesso all'istanza localhost e l'unico database cui avrà connessione sarà il db Test.
MA NON HA DIRITTI DI FARE NULLA!!
*/

-- Voglio dare i diritti a Pippo di fare qualcosa (ad esempio di fare una SELECT su una certa tabella) => diversi livelli di granularità:
grant select on dbo.anagrafica to Pippo

-- Voglio dare i diritti a Pippo di leggere qualsiasi cosa (fare una SELECT su tutte le tabelle):
exec sp_addrolemember 'db_datareader', 'Pippo'

-- Voglio dare i diritti a Pippo di creare tabelle:
GRANT CONTROL ON DATABASE::Test TO Pippo
grant create table to Pippo

-- vedere gli utenti attraverso le viste di sistema:
select * from sys.sysusers

/*

TRANSACTION

Le operazioni o avvengono tutte o non avviene nessuna. Il file su cui si basano le transazioni su SQL SERVER è chiamato TRANSACTION LOG.
Grazie al transaction log, il sistema è in grado di non lasciare le cose a metà.
Il sistema scrive sul file che c'è un inizio di bonifico tra Franco e Ale
->
Poi fa l'update dei dati di Franco
->
scrive che l'ha fatto
->
Poi fa l'update dei dati di Ale
->
scrive che l'ha fatto
->
Concluso.

Nel caso ci fossero problemi, es salta la corrente il database controlla che non ci siano delle attività lasciate a metà. 
Se trova qulacosa lasciato a metà il Database fa il ROLL BACK e ripercorre automaticamente i passaggi da dove si è spaccato
fino alla prima attività.


Le transazioni possono essere IMPLICITE o ESPLICITE.	
	-IMPLICITE -> (le fa lui automaticamente) = esempio di prima
	-ESPLICITE -> noi di codice la facciamo
*/

-- Transazione Implicita

-- creo una tabella con primary key
create table s0 (
	id			int				primary key
	,codice		varchar(20)
)


-- inserisco valori che sono leciti
insert into dbo.s0 values 
	(1, 'alfa')
	,(2, 'bravo')
	,(3, 'charlie')


-- inserisco valori, ma l'ultimo non è lecito perchè va a violare la primary key
insert into dbo.s0 values 
	(4, 'alfa')
	,(5, 'bravo')
	,(1, 'alfa')		--> questa non va bene, quindi fa una transazione IMPLICITA e non carica i dati. NON carica NESSUNO dei record. 
						--> lo ha fatto lui automaticamente


select * from dbo.s0

-- Transazione Esplicita

begin tran	--> apro la transazione

insert into dbo.s0 values	--> inserisco i dati
	(4, 'alfa')
	,(5, 'bravo')
	,(6, 'alfa')

select * from dbo.s0	--> i dati ci sono

rollback	--> ma ci ho ripensato, facendo rollback torno alla situazione iniziale

select * from dbo.s0	--> i dati non ci sono

-- controllo se ho delle transazioni attive:
select @@trancount

begin tran	--> apro la transazione

insert into dbo.s0 values	--> inserisco i dati
	(4, 'alfa')
	,(5, 'bravo')
	,(6, 'alfa')

select * from dbo.s0	--> i dati ci sono

commit	--> ho scritto i dati definitivamente dentro alla tabella

select * from dbo.s0	--> i dati ci sono definitivamente


-- On Prem fino a quando non chiudo la transazione non vedo i dati caricati dentro.
-- NOTA: su Azure si comporta in modo diverso, mi fa rimanere appeso fino a quando non chiudo la 
-- transazione o con un commit o con un rollback
