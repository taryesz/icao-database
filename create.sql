-- CREATE DATABASE MOLC;
GO

USE MOLC;
GO

CREATE TABLE SAMOLOTY (

	-- Atrybuty glowne:

    NRS CHAR(20) PRIMARY KEY CHECK (ISNUMERIC(NRS) = 1 AND LEN(NRS) = 20),
    Cena BIGINT CHECK (Cena >= 1000000 AND Cena <= 1000000000) NOT NULL,
    PojemnoscPasazerska INT CHECK (PojemnoscPasazerska >= 100 AND PojemnoscPasazerska <= 1000) NOT NULL,
    ZasiegLotu INT CHECK (ZasiegLotu >= 300 AND ZasiegLotu <= 7000) NOT NULL,
    Stan VARCHAR(7) CHECK (Stan IN ('Nowy', 'U¿ywany')) NOT NULL,
    Dostepnosc VARCHAR(8) CHECK (Dostepnosc IN ('Sprzeda¿', 'Wynajem')) NOT NULL,
    Model VARCHAR(30) CHECK (LEN(Model) BETWEEN 6 AND 30) NOT NULL,
    RozpietoscSkrzydel INT CHECK (RozpietoscSkrzydel BETWEEN 10 AND 200) NOT NULL,
    Dlugosc INT CHECK (Dlugosc BETWEEN 30 AND 150) NOT NULL

);
GO

CREATE TABLE ZAMOWIENIA (

	-- Atrybuty glowne:

    ID_Zamowienia CHAR(15) PRIMARY KEY CHECK (ISNUMERIC(ID_Zamowienia) = 1 AND LEN(ID_Zamowienia) = 15),
    Data DATE CHECK (Data >= '2000-01-01') NOT NULL

);
GO
  
CREATE TABLE RAPORTY (

	-- Atrybuty glowne:

    ID_Raportu CHAR(15) PRIMARY KEY CHECK (ISNUMERIC(ID_Raportu) = 1 AND LEN(ID_Raportu) = 15),
    Data DATE CHECK (Data >= '2000-01-01') NOT NULL,
    KodAwarii CHAR(10) CHECK (ISNUMERIC(KodAwarii) = 1 AND LEN(KodAwarii) = 10) NOT NULL,

);
GO

CREATE TABLE PRODUCENCI (

	-- Atrybuty glowne:

    Nazwa VARCHAR(30) PRIMARY KEY CHECK (LEN(Nazwa) BETWEEN 5 AND 30 AND Nazwa NOT LIKE '%[^A-Za-z''- ]%'),
    NumerTelefonu VARCHAR(20) CHECK (LEN(NumerTelefonu) BETWEEN 9 AND 20 AND NumerTelefonu NOT LIKE '%[^0-9+]%') NOT NULL,

    Email VARCHAR(40) CHECK (LEN(Email) BETWEEN 11 AND 40 AND Email LIKE '%[a-z0-9._-]%[@]%[a-z0-9._-]%[.]%[a-z]'),
		-- zak³adam, ¿e nie ka¿da firma ma kontakt mailowy (bez "NOT NULL")

    StronaInternetowa VARCHAR(40) CHECK (LEN(StronaInternetowa) BETWEEN 8 AND 40 AND StronaInternetowa NOT LIKE '%[^a-z0-9.:\/@_%-]%')
		-- zak³adam, ¿e nie ka¿da firma ma stronê internetow¹ (bez "NOT NULL")

);
GO

CREATE TABLE FIRMY_LOGISTYCZNE (

	-- Atrybuty glowne:

    ID_Firmy CHAR(15) PRIMARY KEY CHECK (ISNUMERIC(ID_Firmy) = 1 AND LEN(ID_Firmy) = 15),
    Nazwa VARCHAR(50) CHECK (LEN(Nazwa) BETWEEN 5 AND 50 AND Nazwa NOT LIKE '%[^A-Za-z''- ]%') NOT NULL,
    Kraj VARCHAR(25) CHECK (LEN(Kraj) BETWEEN 5 AND 25 AND Kraj NOT LIKE '%[^A-Za-z -]%') NOT NULL

);
GO

CREATE TABLE HANGARY (

	-- Atrybuty glowne:

    ID_Hangaru CHAR(15) PRIMARY KEY CHECK (ISNUMERIC(ID_Hangaru) = 1 AND LEN(ID_Hangaru) = 15),
    Kraj VARCHAR(25) CHECK (LEN(Kraj) BETWEEN 5 AND 25 AND Kraj NOT LIKE '%[^A-Za-z -]%') NOT NULL,
    Miasto VARCHAR(25) CHECK (LEN(Miasto) BETWEEN 2 AND 25 AND Miasto NOT LIKE '%[^A-Za-z -]%') NOT NULL

);
GO

CREATE TABLE DZIALY (

	-- Atrybuty glowne:

    ID_Dzialu CHAR(15) PRIMARY KEY CHECK (ISNUMERIC(ID_Dzialu) = 1 AND LEN(ID_Dzialu) = 15),

    Nazwa VARCHAR(50) CHECK (LEN(Nazwa) BETWEEN 5 AND 50 AND Nazwa NOT LIKE '%[^A-Za-z -]%') UNIQUE NOT NULL,
		-- zak³adam, ¿e nazwy dzia³ów nie mog¹ siê powtarzaæ (dodajê "UNIQUE")

    NumerTelefonu VARCHAR(20) CHECK (LEN(NumerTelefonu) BETWEEN 9 AND 20 AND NumerTelefonu NOT LIKE '%[^0-9+]%') NOT NULL,

    Email VARCHAR(40) CHECK (LEN(Email) BETWEEN 11 AND 40 AND Email LIKE '%[a-z0-9._-]%[@]%[a-z0-9._-]%[.]%[a-z]')
		-- zak³¹dam, ¿e nie ka¿dy dzia³ ma kontakt mailowy (bez "NOT NULL")

);
GO

CREATE TABLE LINIE_LOTNICZE (
	
	-- Atrybuty glowne:

    ID_Linii CHAR(15) PRIMARY KEY CHECK (ISNUMERIC(ID_Linii) = 1 AND LEN(ID_Linii) = 15),
    Nazwa VARCHAR(50) CHECK (LEN(Nazwa) BETWEEN 5 AND 50 AND Nazwa NOT LIKE '%[^A-Za-z''- ]%') NOT NULL,

    KodMOLC CHAR(4) CHECK (KodMOLC COLLATE Latin1_General_CS_AS LIKE '[A-Z][A-Z][A-Z][A-Z]') UNIQUE NOT NULL,
		-- w rzeczywistoœci, kod MOLC jest unikatowy dla ka¿dej linii lotniczej (dodajê "UNIQUE")

    KodIATA CHAR(3) CHECK (KodIATA COLLATE Latin1_General_CS_AS LIKE '[A-Z][A-Z][A-Z]') UNIQUE NOT NULL
		-- w rzeczywistoœci, kod IATA jest unikatowy dla ka¿dej linii lotniczej (dodajê "UNIQUE")

);
GO

CREATE TABLE PRACOWNIK_SAMOLOTU (

	-- Atrybuty glowne:

    ID_Pracownika CHAR(15) PRIMARY KEY CHECK (ISNUMERIC(ID_Pracownika) = 1 AND LEN(ID_Pracownika) = 15),
    Imie VARCHAR(15) CHECK (LEN(Imie) BETWEEN 3 AND 15 AND Imie NOT LIKE '%[^A-Za-z -]%') NOT NULL,
    Nazwisko VARCHAR(30) CHECK (LEN(Nazwisko) BETWEEN 2 AND 30 AND Nazwisko NOT LIKE '%[^A-Za-z -]%') NOT NULL,
    Stanowisko VARCHAR(30) CHECK (LEN(Stanowisko) BETWEEN 5 AND 30 AND Stanowisko NOT LIKE '%[^A-Za-z -]%') NOT NULL

);
GO

CREATE TABLE LOGI (

	-- Atrybuty glowne:

    ID_Pracownika CHAR(15) CHECK (ISNUMERIC(ID_Pracownika) = 1 AND LEN(ID_Pracownika) = 15),
    NRS CHAR(20) CHECK (ISNUMERIC(NRS) = 1 AND LEN(NRS) = 20),
    Data DATE CHECK (Data >= '2000-01-01') NOT NULL,
    
	PRIMARY KEY (ID_Pracownika, NRS)
		-- ID_Pracownika & NRS s¹ kluczami g³ównymi, a wiêc s¹ "NOT NULL" czyli musz¹ mieæ referencjê

);
GO



-- DODANIE ZWIAZKOW -----------------------------------------------------------------------------------------------------------------------



ALTER TABLE SAMOLOTY 
ADD 
	
	-- RBD / Zwiazki:

	NumerZamowienia CHAR(15) CHECK ((ISNUMERIC(NumerZamowienia) = 1 AND LEN(NumerZamowienia) = 15) OR NumerZamowienia IS NULL),
		-- samolot mo¿e byæ czêœci¹ zamówienia, ale nie koniecznie (czyli mo¿e byæ NULL); 
		-- st¹d wyp³ywa, ¿e powinniœmy dodaæ "OR NumerZamowienia IS NULL" (~ "NIE musi byc")

	PotencjalnyKlient CHAR(15) CHECK ((ISNUMERIC(PotencjalnyKlient) = 1 AND LEN(PotencjalnyKlient) = 15) OR PotencjalnyKlient IS NULL), 
		-- samolot mo¿e byæ analizowany przez dzia³, ale nie koniecznie; 
		-- st¹d wyp³ywa, ¿e powinniœmy dodaæ "OR PotencjalnyKlient IS NULL" (~ "NIE musi byc")

	Producent VARCHAR(30) CHECK (LEN(Producent) BETWEEN 5 AND 30 AND Producent NOT LIKE '%[^A-Za-z''- ]%') NOT NULL,
		-- samolot powinien mieæ producenta (nie mo¿e byæ tak ¿e nie ma);
		-- st¹d wyp³ywa, ¿e powinniœmy dodaæ "NOT NULL" (~ "musi byc")
	
	FOREIGN KEY (NumerZamowienia) REFERENCES ZAMOWIENIA(ID_Zamowienia) ON DELETE SET NULL ON UPDATE CASCADE,
		-- gdy anulujemy zamówienie, nie oznacza to ¿e samolot teraz nie mo¿e byæ sprzedany, wiêc ustawiamy NULL (~ nie jest jeszcze kupiony)
		-- gdy dane zamówienia zostnan¹ zmienione, samolot nadal pozostaje czêœci¹ tego zamówienia, wiêc CASCADE (~ uaktualnij dane)

	FOREIGN KEY (PotencjalnyKlient) REFERENCES DZIALY(ID_Dzialu) ON DELETE SET NULL ON UPDATE CASCADE, 
		-- gdy usuniemy dzia³, samolot "utraci interes", ale nie oznacza to ¿e samolot teraz nie mo¿e byæ sprzedany, wiêc ustawiamy NULL (~ nikt siê nie zainteresowa³) 
		-- gdy zmieni¹ siê dane o dziale który jest zainteresowany tym samolotem, z samolotem nic siê nie dzieje, wiêc CASCADE (~ uaktualnij dane)

	FOREIGN KEY (Producent) REFERENCES PRODUCENCI(Nazwa) ON DELETE CASCADE ON UPDATE CASCADE 
		-- gdy producent zamyka swój biznes, samolot traci markê tej firmy, wiêc dwie opcje: "ON DELETE CASCADE" b¹dŸ "ON DELETE NO ACTION". 
		-- wybieram "ON DELETE CASCADE" z za³o¿enia, ¿e po zamkniêciu biznesu, producent zabrania sprzedawaæ swoje samoloty, wiêc usuwamy je z bazy
		-- gdy dane o producencie zosta³y zmienione, z samolotem nic siê nie dzieje, wiêc CASCADE (~ uaktualnij dane)

GO

ALTER TABLE ZAMOWIENIA
ADD
	
	-- RBD / Zwiazki:

	MiejsceDostawy CHAR(15) CHECK (ISNUMERIC(MiejsceDostawy) = 1 AND LEN(MiejsceDostawy) = 15) NOT NULL,
		-- zamówienie NA PEWNO jest dostarczane do jednego z hangarów linii lotniczej;
		-- st¹d wyp³ywa, ¿e powinniœmy dodaæ "NOT NULL" (~ "musi byc")

	Dostawca CHAR(15) CHECK (ISNUMERIC(Dostawca) = 1 AND LEN(Dostawca) = 15) NOT NULL,
		-- zamówienie NA PEWNO ma kogoœ kto realizuje dostawê;
		-- st¹d wyp³ywa, ¿e powinniœmy dodaæ "NOT NULL" (~ "musi byc")

	Zlecajacy CHAR(15) CHECK (ISNUMERIC(Zlecajacy) = 1 AND LEN(Zlecajacy) = 15) NOT NULL,
		-- zamówienie NA PEWNO ma kogoœ kto to zamówienie z³o¿y³;
		-- st¹d wyp³ywa, ¿e powinniœmy dodaæ "NOT NULL" (~ "musi byc")

	FOREIGN KEY (MiejsceDostawy) REFERENCES HANGARY(ID_Hangaru) ON DELETE NO ACTION ON UPDATE CASCADE,
		-- gdy hangar zostaje usuniêty, nie wiemy dok¹d mamy przywieŸæ nasz samolot, wiêc zamówienie zostaje anulowane, ustawiamy NO ACTION
		-- gdy dane o miejscu docelowym zosta³y zmienione, zmieniamy je w zamówieniu, wiêc CASCADE (~ uaktualnij dane)
			-- [ ewentualnie mo¿na zrobiæ "ON UPDATE NO ACTION" czyli zabroniæ zmieniaæ miejsce docelowe z uwagi trudnoœci transportowania samolotu ]

	FOREIGN KEY (Dostawca) REFERENCES FIRMY_LOGISTYCZNE(ID_Firmy) ON DELETE NO ACTION ON UPDATE CASCADE,
		-- gdy dostawca chce zamkn¹æ swój biznes, musi skoñczyæ wszystkie swoje aktualne dostawy - nie mo¿ê nagle je rzuciæ, ustawiamy NO ACTION
		-- gdy dane o dostawcy zosta³y zmienione, zmieniamy je w zamówieniu, wiêc CASCADE (~ uaktualnij dane)

	FOREIGN KEY (Zlecajacy) REFERENCES DZIALY(ID_Dzialu) ON DELETE NO ACTION ON UPDATE NO ACTION;
		-- gdy zlecaj¹cy zostaje usuniêty, oznacza to, ¿e zamówienie musi byæ anulowane, ustawiamy CASCADE 

		--		---> UPD: powy¿sze ustawienie nie zadziala, bo dostajemy pêtlê kaskadow¹. Nowe za³o¿enie: 
		--				  dzia³ nie mo¿e zostaæ usuniêty z bazy póki ma zamówienia w trakcie wykonania, ustawiamy NO ACTION

		-- dane o zlecajacym nie mog¹ ulec zmianie, ustawiamy NO ACTION

GO

ALTER TABLE RAPORTY
ADD

	-- RBD / Zwiazki:

	Pojazd CHAR(20) CHECK (ISNUMERIC(Pojazd) = 1 AND LEN(Pojazd) = 20) NOT NULL,
		-- raport NA PEWNO odnosi siê do konkretnego samolotu (raport bez referencji do samolotu nie ma sensu);
		-- st¹d wyp³ywa, ¿e powinniœmy dodaæ "NOT NULL" (~ "musi byc")

	Przetwarzajacy CHAR(15) CHECK ((ISNUMERIC(Przetwarzajacy) = 1 AND LEN(Przetwarzajacy) = 15) OR Przetwarzajacy IS NULL),
		-- raport MO¯E byæ analizowany (zebrany) przez dzia³, ale NIE KONIECZNIE;
		-- st¹d wyp³ywa, ¿e powinniœmy dodaæ "OR Przetwarzajacy IS NULL" (~ "NIE musi byc")

	FOREIGN KEY (Pojazd) REFERENCES SAMOLOTY(NRS) ON DELETE CASCADE ON UPDATE CASCADE, 
		-- gdy samolot zostaje usuniêty, po co nam przechowywaæ jego dane w bazie? Ustawiamy CASCADE
		-- gdy dane o samolocie zosta³y zmienione, zmieniamy je w zamówieniu, wiêc CASCADE (~ uaktualnij dane)

	FOREIGN KEY (Przetwarzajacy) REFERENCES DZIALY(ID_Dzialu) ON DELETE NO ACTION ON UPDATE NO ACTION
		-- gdy dzia³ przesta³ zbieraæ dane o samolocie, nie oznacza to, ¿e raporty te ulegaj¹ zmianie, ustawiamy NULL

		--		---> UPD: powy¿sze ustawienie nie zadziala, bo dostajemy pêtlê kaskadow¹. Nowe za³o¿enie: 
		--				  dzia³ nie mo¿e zostaæ usuniêty z bazy gdy do tego dzia³u jest przywi¹zany raport, ustawiamy NO ACTION
		--				  raporty mog¹ byæ "kopiowane", ale mieæ ró¿nych przetwarzaj¹cych, wiêc nie ma potrzeby w aktualizowaniu, ustawiamy NO ACTION				  
		-- gdy dane o dziale zosta³y zmienione, zmieniamy je w zamówieniu, wiêc CASCADE (~ uaktualnij dane)

GO

ALTER TABLE HANGARY
ADD

	-- RBD / Zwiazki:

	Wlasciciel CHAR(15) CHECK (ISNUMERIC(Wlasciciel) = 1 AND LEN(Wlasciciel) = 15) NOT NULL,
		-- hangar NA PEWNO nale¿y do którejœ z linii lotniczych;
		-- st¹d wyp³ywa, ¿e powinniœmy dodaæ "NOT NULL" (~ "musi byc")

	FOREIGN KEY (Wlasciciel) REFERENCES LINIE_LOTNICZE(ID_Linii) ON DELETE CASCADE ON UPDATE CASCADE
		-- gdy linia lotnicza siê zamknê³a, hangar usuwany jest z bazy jako czêœæ linii lotniczej, ustawiamy CASCADE
		-- gdy dane o linii lotniczej zosta³y zmienione, zmieniamy je w zamówieniu, wiêc CASCADE (~ uaktualnij dane)
	
GO

ALTER TABLE DZIALY
ADD

	-- RBD / Zwiazki:

	Wlasciciel CHAR(15) CHECK (ISNUMERIC(Wlasciciel) = 1 AND LEN(Wlasciciel) = 15) NOT NULL,
		-- dzia³ NA PEWNO nale¿y do którejœ z linii lotniczych;
		-- st¹d wyp³ywa, ¿e powinniœmy dodaæ "NOT NULL" (~ "musi byc")

	FOREIGN KEY (Wlasciciel) REFERENCES LINIE_LOTNICZE(ID_Linii) -- !
		-- gdy linia lotnicza siê zamyka, jej dzia³y równie¿ siê zamykaj¹, ustawiamy CASCADE
		-- gdy dane o linii lotniczej zosta³y zmienione, zmieniamy je w zamówieniu, wiêc CASCADE (~ uaktualnij dane)
	
GO

ALTER TABLE PRACOWNIK_SAMOLOTU
ADD

	-- RBD / Zwiazki:

	Naczelnik CHAR(15) CHECK (ISNUMERIC(Naczelnik) = 1 AND LEN(Naczelnik) = 15) NOT NULL,
		-- pracownik NA PEWNO nale¿y do któregoœ z dzia³ów linii lotniczej (nie ma pracowników "niezale¿nych");
		-- st¹d wyp³ywa, ¿e powinniœmy dodaæ "NOT NULL" (~ "musi byc")
		
	FOREIGN KEY (Naczelnik) REFERENCES DZIALY(ID_Dzialu) ON DELETE CASCADE ON UPDATE CASCADE 
		-- gdy dzia³ siê zamyka, osoba traci miejsce pracy (dzia³ jest bezpoœrednim pracodawc¹), ustawiamy CASCADE;
		-- gdy dane o dziale zosta³y zmienione, zmieniamy je w zamówieniu, wiêc CASCADE (~ uaktualnij dane)
		
GO

ALTER TABLE LOGI
ADD

	-- RBD / Zwiazki:

    FOREIGN KEY (ID_Pracownika) REFERENCES PRACOWNIK_SAMOLOTU(ID_Pracownika) ON DELETE NO ACTION ON UPDATE NO ACTION,
		-- musimy przechowywac dane o pracownikach caly czas wiec NO ACTION
		-- kazde korzystanie z samolotu jest monitorowane, zakaz zmiany danych, wiec NO ACTION

    FOREIGN KEY (NRS) REFERENCES SAMOLOTY(NRS) ON DELETE CASCADE ON UPDATE NO ACTION
		-- gdy usuwamy samolot, nie potrzebujemy danych o jego korzystaniu, wiec CASCADE
		-- kazde korzystanie z samolotu jest monitorowane, zakaz zmiany danych, wiec NO ACTION