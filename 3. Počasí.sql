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