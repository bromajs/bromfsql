## vytvoøení view pocasi ###
CREATE OR REPLACE VIEW pocasi AS
select 
country,
datum,
prùmìrná_teplota,
srazky,
maximalnivitr
from countries as c
join
(       select w1.time,
        	convert(w1.date,date) as datum,
        	w1.city,
        	round(avg(cast ((REPLACE (temp,'°c',' ')) AS integer)),2) AS prùmìrná_teplota 
        FROM weather as w1
        where w1.time in ('06:00','09:00','12:00','15:00','18:00','21:00')   
       GROUP BY w1.city, datum
    ) w1
    ON c.capital_city = w1.city
join
(      select     w2.city,
			convert(date,date) as datum2,
           	count(CAST((REPLACE (rain,' mm',''))AS float)) AS srazky 
        FROM weather as w2
        WHERE city IS NOT NULL AND CAST((REPLACE (rain,' mm',''))AS float) > 0
      GROUP BY city, datum2
    ) w2
	ON c.capital_city = w2.city
	AND datum = datum2
join
(     select     w3.city,
			convert(date,date) as datum3,
           	max(CAST((REPLACE (gust,'km/h',''))AS integer)) as maximalnivitr
        FROM weather as w3
      GROUP BY city, datum3
    ) w3
	ON c.capital_city = w3.city
	AND datum = datum3;
## vytvoøení view promìnné_stat ##
CREATE OR REPLACE VIEW promìnné_stát AS
SELECT 
	r.country, 
	population_density,
	e.GDP/z.population as HPDnaObyvatele,
	e.gini,
	e.mortaliy_under5,
	z.median_age_2018,
	r.religion , 
    round( r.population / r2.total_population_2020 * 100, 2 ) as podilnabozenstvi,
   (l2.life_expectancy - l1.life_expectancy) as	rozdílmezioèekávanoudoboudožití 
    FROM religions r 
join
(
        SELECT l1.country, l1.year, life_expectancy
        FROM life_expectancy l1
        WHERE l1.year = 1965
    ) l1
    ON r.country = l1.country
join
(
        SELECT l2.country, l2.year, life_expectancy
        FROM life_expectancy l2
        WHERE l2.year = 2015
    ) l2
    ON r.country = l2.country
join
(
        SELECT r.country, r.year,  sum(r.population) as total_population_2020
        FROM religions r 
        WHERE r.year = 2020 and r.country != 'All Countries'
        GROUP BY r.country
    ) r2
    ON r.country = r2.country
    AND r.year = r2.year
    AND r.population > 0
join economies as e
on r.country = e.country 
join countries as z
on r.country = z.country 
where 
	e.year=2018;
## vytvoøení èasovì_promìnné ##
CREATE OR REPLACE VIEW èasovì_promìnné AS
select
#na základì mìsícù dojde k pøiøazení roèního obodovbí  
#	zima - 0
#	jaro - 1
#	léto - 2
#	podzim - 3
country,
`date`,
(case when month(date) in (12, 1, 2) then '0'
      when month(date) in (3, 4, 5) then '1'
      when month(date) in (6, 7, 8) then '2'
      when month(date) in (9, 10, 11) then '3'
 	  end) as RoèníObdobí,
 	  #pokud se jedná o pracovní dny  2,3,4,5,6 zapíšu jednicku
 	  #pokud se jedná o víkend  1,7 zapíšu nulu
 	  (case when DAYOFWEEK(date) in (2,3,4,5,6) then '1'
       when DAYOFWEEK(date) in (1,7) then '0'
 end) as PracovníDen
from covid19_basic_differences;
## vytvoøení celkové tabulky ##
create or replace table t_Filip_Brom_projekt_SQL_final as
select 
èasovì_promìnné.country,
èasovì_promìnné.date,
RoèníObdobí,
PracovníDen,
prùmìrná_teplota,
srazky,
maximalnivitr,
population_density,
HPDnaObyvatele,
gini,
median_age_2018,
mortaliy_under5,
religion,
podilnabozenstvi,
rozdílmezioèekávanoudoboudožití
from èasovì_promìnné 
join pocasi on pocasi.datum = èasovì_promìnné.date and pocasi.country = èasovì_promìnné.country 
join promìnné_stát on promìnné_stát.country = èasovì_promìnné.country;