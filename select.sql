USE MOLC;
GO

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/* SELECT NR 1.

	Scenario:

		CEO of "Lot Airlines" wants to generate a report on the workforce distribution in all departments of his airline.

	Query:

		Count how many employees work in each department (list the ID and name) of the airline with identifier X.

*/

SELECT DZIALY.ID_Dzialu AS Nr_Identyfikacyjny_Dzialu, DZIALY.Nazwa AS Nazwa_Dzialu, COUNT(PRACOWNIK_SAMOLOTU.ID_Pracownika) AS Liczba_Pracownikow
	FROM DZIALY
	JOIN PRACOWNIK_SAMOLOTU ON PRACOWNIK_SAMOLOTU.Naczelnik = DZIALY.ID_Dzialu
	WHERE DZIALY.Wlasciciel = '000000000000001'
	GROUP BY DZIALY.ID_Dzialu, DZIALY.Nazwa;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/* SELECT NR 2.

	Scenario:

		"Lot Airlines" is looking for a new high-capacity passenger aircraft (e.g., 700 people). The employees of the airline's 
		departments have found several options from various manufacturers, and now they need to provide the CEO with the average 
		price of the aircraft from each of them, to later choose the company with the best "price/quality" ratio.

	Query:

		Calculate the average prices of new aircraft, found by the departments of airline X, which have not been ordered yet, with passenger capacity Y, from various manufacturers.

*/

SELECT SAMOLOTY.PotencjalnyKlient AS Nr_Identyfikacyjny_Dzialu, PRODUCENCI.Nazwa AS Producent, AVG(Cena) AS Srednia_Cena_Samolotu
	FROM SAMOLOTY
	JOIN PRODUCENCI ON SAMOLOTY.Producent = PRODUCENCI.Nazwa
	WHERE 
		NumerZamowienia IS NULL 
		AND Stan = 'Nowy' 
		AND PojemnoscPasazerska = 700
		AND PotencjalnyKlient IN (
			SELECT ID_Dzialu 
				FROM DZIALY 
				WHERE Wlasciciel = '000000000000001'
		)
	GROUP BY PRODUCENCI.Nazwa, SAMOLOTY.PotencjalnyKlient

GO

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/* SELECT NR 3.

	Scenario:

		Employees of "Lot Airlines" have placed several orders, which have been delivered to various hangars (in different cities and countries). 
		They need to create a flight plan for the aircraft currently located in Germany, starting with those with the smallest passenger capacity.

	Query:

		Show the aircraft (and the cities where they are located) owned by airline X, which are currently in the country Y, in ascending order according to passenger capacity.

*/

CREATE VIEW POLOZENIE_SAMOLOTU AS
SELECT
    SAMOLOTY.NRS AS Samolot,
	SAMOLOTY.PojemnoscPasazerska AS Pojemnosc,
    HANGARY.Kraj AS Aktualny_Kraj,
    HANGARY.Miasto AS Aktualne_Miasto
FROM SAMOLOTY
JOIN ZAMOWIENIA ON SAMOLOTY.NumerZamowienia = ZAMOWIENIA.ID_Zamowienia
JOIN HANGARY ON ZAMOWIENIA.MiejsceDostawy = HANGARY.ID_Hangaru
WHERE
    HANGARY.Wlasciciel = '000000000000001';

GO

-- select * from POLOZENIE_SAMOLOTU

SELECT
    POLOZENIE_SAMOLOTU.Samolot,
    POLOZENIE_SAMOLOTU.Pojemnosc,
    POLOZENIE_SAMOLOTU.Aktualne_Miasto AS Miasto
FROM
	POLOZENIE_SAMOLOTU
WHERE
    POLOZENIE_SAMOLOTU.Aktualny_Kraj = 'Germany'
ORDER BY
    POLOZENIE_SAMOLOTU.Pojemnosc ASC;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/* SELECT NR 4.

	Scenario:

		The task of the analyst at "Lot Airlines" is to gather information about logistics companies and assess their involvement in delivering orders for the airline. 
		They want to find out which logistics companies handle countries essential to the operations of this airline, and also check how many orders are assigned to 
		each of these companies.

	Query:

		Show the logistics companies, their locations, and the quantity of orders assigned to them, where the location matches that of the hangars owned by airline X to 
		which they delivered those orders.
*/

SELECT
    FIRMY_LOGISTYCZNE.ID_Firmy,
    FIRMY_LOGISTYCZNE.Nazwa,
    FIRMY_LOGISTYCZNE.Kraj,
    (
        SELECT COUNT(*)
        FROM ZAMOWIENIA
        WHERE ZAMOWIENIA.Dostawca = FIRMY_LOGISTYCZNE.ID_Firmy
    ) AS Ilosc_Zamowien
FROM FIRMY_LOGISTYCZNE
WHERE FIRMY_LOGISTYCZNE.Kraj IN (
    SELECT FIRMY_LOGISTYCZNE.Kraj 
    FROM FIRMY_LOGISTYCZNE
    INTERSECT
    SELECT HANGARY.Kraj
    FROM HANGARY
	WHERE HANGARY.Wlasciciel = '000000000000001'
)
ORDER BY Nazwa DESC;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/* SELECT NR 5.

	Scenario:

		The hangar employees at "Lot Airlines" want to create a list of aircraft that need repairs. However, 
		they have so many of them that they decided to prioritize repairs based on the date of the reported issues:

		* From 01.01.2023 to 31.05.2023 - Reports from this date range and the corresponding aircraft are treated as those that must be addressed urgently.
		* From 01.06.2023 to 31.12.2023 - Urgent but not the most critical.
		* From 01.01.2024 to 31.12.2024 - Can wait a bit.

		They want to count how many aircraft fall into each of these priority categories.

	Query:

		Count the number of aircraft belonging to hangar X with different priority levels as specified above.

*/

GO 

WITH PRIORYTETY AS (
    SELECT
        RAPORTY.Pojazd AS Samolot,
        RAPORTY.ID_Raportu AS Nr_Identyfikacyjny_Raportu,
        RAPORTY.Data,
        RAPORTY.KodAwarii AS Kod_Awarii,
        CASE
            WHEN RAPORTY.Data BETWEEN '2023-01-01' AND '2023-05-31' THEN 'Wysoki'
            WHEN RAPORTY.Data BETWEEN '2023-06-01' AND '2023-12-31' THEN 'Œredni'
            WHEN RAPORTY.Data BETWEEN '2024-01-01' AND '2024-12-31' THEN 'Niski'
            ELSE 'Inny Przypadek'
        END AS Priorytet
    FROM
        RAPORTY
    JOIN SAMOLOTY ON RAPORTY.Pojazd = SAMOLOTY.NRS
    JOIN ZAMOWIENIA ON SAMOLOTY.NumerZamowienia = ZAMOWIENIA.ID_Zamowienia
    JOIN HANGARY ON ZAMOWIENIA.MiejsceDostawy = HANGARY.ID_Hangaru
    WHERE 
        HANGARY.ID_Hangaru = '000000000000002'
)

SELECT
    PRIORYTETY.Priorytet AS Priorytet,
    COUNT(PRIORYTETY.Priorytet) AS Ilosc_Samolotow
FROM PRIORYTETY
GROUP BY PRIORYTETY.Priorytet;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/* SELECT NR 6.

	Scenario:

		The CEO of "Lot Airlines" intends to investigate which employees experienced the highest number of incidents in large aircraft (with a passenger capacity > 200) 
		during the year 2022.

	Query:

		Create a list of employees from the company. For each of them, count the number of incidents that occurred in 2022 on larger aircraft 
		where they were involved. Sort the results in descending order.

*/

GO 

WITH ZESTAWIENIE AS (
    SELECT
        PRACOWNIK_SAMOLOTU.ID_Pracownika,
        PRACOWNIK_SAMOLOTU.Imie,
        PRACOWNIK_SAMOLOTU.Nazwisko,
        COUNT(*) AS LiczbaAwarii
    FROM
        LOGI 
    JOIN
        PRACOWNIK_SAMOLOTU ON LOGI.ID_Pracownika = PRACOWNIK_SAMOLOTU.ID_Pracownika
    JOIN
        SAMOLOTY ON LOGI.NRS = SAMOLOTY.NRS
	JOIN 
		DZIALY ON PRACOWNIK_SAMOLOTU.Naczelnik = DZIALY.ID_Dzialu
    WHERE
        LOGI.Data BETWEEN '2023-01-01' AND '2024-12-31'
        AND SAMOLOTY.PojemnoscPasazerska > 200
		AND DZIALY.Wlasciciel = '000000000000001'
    GROUP BY
        PRACOWNIK_SAMOLOTU.ID_Pracownika, PRACOWNIK_SAMOLOTU.Imie, PRACOWNIK_SAMOLOTU.Nazwisko
)

SELECT
    ZESTAWIENIE.ID_Pracownika,
    ZESTAWIENIE.Imie,
    ZESTAWIENIE.Nazwisko,
    COALESCE(ZESTAWIENIE.LiczbaAwarii, 0) AS Liczba_Awarii
FROM
    ZESTAWIENIE
ORDER BY
    LiczbaAwarii DESC;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/* SELECT NR 7.

	Scenario:

		A European airline is looking for aircraft for lease but wants to analyze the aircraft market first, 
		considering prices in euros for clarity. The American date format is causing confusion for potential clients.

	Query:

		Show a list of all aircraft for lease, including their model, prices in $ and EUR, as well as order details and the order date.

*/

DECLARE @KursWymiany DECIMAL(10, 4) = 0.85; 

SELECT 
    S.NRS AS NumerRejestracyjny,
    S.Model,
    FORMAT(S.Cena, 'C', 'en-US') AS Cena_Dolar,
    FORMAT(S.Cena * @KursWymiany, 'C', 'en-US') AS Cena_Euro,
    COALESCE(Z.ID_Zamowienia, 'Brak zamówienia') AS ID_Zamowienia,
    COALESCE(CONVERT(VARCHAR, Z.Data, 103), 'Brak daty') AS DataZamowienia
FROM SAMOLOTY S
LEFT JOIN ZAMOWIENIA Z ON S.NumerZamowienia = Z.ID_Zamowienia
WHERE S.Dostepnosc = 'Wynajem';

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/* SELECT NR 8.

	Scenario:

		The director of one of the hangars at "Lot Airlines" wants to calculate the dimensions (area) of recently purchased aircraft to determine if they 
		will all fit in the hangar.

	Query:

		Calculate the dimensions of each aircraft included in the latest order commissioned by airline X.

*/

SELECT SAMOLOTY.NRS, SAMOLOTY.Dlugosc * SAMOLOTY.RozpietoscSkrzydel AS Pole
	FROM SAMOLOTY
	JOIN ZAMOWIENIA ON ZAMOWIENIA.ID_Zamowienia = SAMOLOTY.NumerZamowienia
	WHERE 
		ZAMOWIENIA.MiejsceDostawy = '000000000000002'
		AND ZAMOWIENIA.data = (SELECT MAX(data) FROM ZAMOWIENIA);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- REMOVE VIEW:

drop view POLOZENIE_SAMOLOTU