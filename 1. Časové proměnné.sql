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