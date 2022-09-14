-- creare una funzione che riporti i top 3 comuni per massimo numero di coniugati.
-- nota: nel comune NON deve essere presente la citta che fa da provincia, es: per la provincia di parma, 
-- la città di parma deve essere esclusa.

ALTER function [dbo].[f_coniugati] (@provincia as varchar(100)) returns table 
as 
return

	select top (3)
		provincia
		,comune
		,max(coniugati) as max_coniugati
	from (select REPLACE(Provincia, '''', '') as Provincia, Comune, Coniugati from people.DemografiaItalia) as a
	where provincia = @provincia and Comune <> @provincia
	group by Comune, provincia
	order by max(Coniugati) desc


select *
from dbo.f_coniugati('parma')

select *
from people.DemografiaItalia
where Provincia = 'parma'
order by comune

select * from dbo.f_coniugati('Viterbo')
select * from people.StgComuni
select REPLACE(Provincia, '''', '') as Provincia, Comune, Coniugati from people.DemografiaItalia

select
b.*
from 
	(select distinct REPLACE(Provincia, '''', '') as provincia from [people].[GeoItalia]) as a
	cross apply
	dbo.f_coniugati(a.Provincia) as b


