## vytvo�en� view pocasi ###
CREATE OR REPLACE VIEW pocasi AS
select 
country,
datum,
pr�m�rn�_teplota,
srazky,
maximalnivitr
from countries as c
join
(       select w1.time,
        	convert(w1.date,date) as datum,
        	w1.city,
        	round(avg(cast ((REPLACE (temp,'�c',' ')) AS integer)),2) AS pr�m�rn�_teplota 
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
## vytvo�en� view prom�nn�_stat ##
CREATE OR REPLACE VIEW prom�nn�_st�t AS
SELECT 
	r.country, 
	population_density,
	e.GDP/z.population as HPDnaObyvatele,
	e.gini,
	e.mortaliy_under5,
	z.median_age_2018,
	r.religion , 
    round( r.population / r2.total_population_2020 * 100, 2 ) as podilnabozenstvi,
   (l2.life_expectancy - l1.life_expectancy) as	rozd�lmezio�ek�vanoudoboudo�it� 
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
## vytvo�en� �asov�_prom�nn� ##
CREATE OR REPLACE VIEW �asov�_prom�nn� AS
select
#na z�klad� m�s�c� dojde k p�i�azen� ro�n�ho obodovb�  
#	zima - 0
#	jaro - 1
#	l�to - 2
#	podzim - 3
country,
`date`,
(case when month(date) in (12, 1, 2) then '0'
      when month(date) in (3, 4, 5) then '1'
      when month(date) in (6, 7, 8) then '2'
      when month(date) in (9, 10, 11) then '3'
 	  end) as Ro�n�Obdob�,
 	  #pokud se jedn� o pracovn� dny  2,3,4,5,6 zap�u jednicku
 	  #pokud se jedn� o v�kend  1,7 zap�u nulu
 	  (case when DAYOFWEEK(date) in (2,3,4,5,6) then '1'
       when DAYOFWEEK(date) in (1,7) then '0'
 end) as Pracovn�Den
from covid19_basic_differences;
## vytvo�en� celkov� tabulky ##
create or replace table t_Filip_Brom_projekt_SQL_final as
select 
�asov�_prom�nn�.country,
�asov�_prom�nn�.date,
Ro�n�Obdob�,
Pracovn�Den,
pr�m�rn�_teplota,
srazky,
maximalnivitr,
population_density,
HPDnaObyvatele,
gini,
median_age_2018,
mortaliy_under5,
religion,
podilnabozenstvi,
rozd�lmezio�ek�vanoudoboudo�it�
from �asov�_prom�nn� 
join pocasi on pocasi.datum = �asov�_prom�nn�.date and pocasi.country = �asov�_prom�nn�.country 
join prom�nn�_st�t on prom�nn�_st�t.country = �asov�_prom�nn�.country;