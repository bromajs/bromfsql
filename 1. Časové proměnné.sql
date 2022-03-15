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