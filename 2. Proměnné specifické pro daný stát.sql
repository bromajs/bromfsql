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