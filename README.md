**Projekt SQL Engeto Akademie**

\1. Časové proměnné

Na základě měsíců je ke každému řádku přiřazeno roční období: 

zima - 0

jaro - 1

léto - 2

podzim – 3 .

V případě, že se jedná o pracovní den je přiřazena řádku 1, v případě, že se jedná o víkend je zapsána nula.

\2. Proměnné specifické pro daný stát

Nejdříve je vybrána hustota zalidnění a spočítáno HDP na obyvatele za pomocí
GDP (získáno v tabulce economies)
population (získáno v tabulce countries)
jako GDP/population. 

V dalším kroku je vybrán koeficient GINI, který však pro některé země chybí, dětská úmrtnost. Na závěr je vybrána víra a spočteno její zastoupení u jednotlivé země.
# 3. Počasí
V úvodu je spočítána průměrná teplota pro denní hodiny, celkový počet hodin, ve kterých byl zaznamenán déšť a nalezena maximální hodnota nárazu větru.
# 4. Vytvoření celkové tabulky
Poslední část spojuje všechny vytvořené náhledy dohromady, a to na základě země a datumu.



