# ICAO Database

This repository contains several SQL files that create a database for ICAO (International Civil Aviation Organization) 

The goal of the database is to create a convenient monitoring system for aircrafts available on the market, facilitating the management of fleets for individual airlines. The idea behind it is similar to what we can see on such platforms as OLX, Amazon, AliExpress, etc.. just for planes :)

## Examplementary Usage Scenario

There could be an airline that is looking for a new Boeing - a big one, that can sit a couple of hundreds of people inside, can fly as far as possible. One of the departments' team jumps into this database and sets those criterias - they get a list of planes that suit them.

The team can also analyze all the problems that have ever occured to this specific aircraft, look through the history of usage, who was the crew serving that specific day.

Finally, they can place an order, track it and specify a hangar the plane has to be delivered to!

> For more scenarios visit `select.sql` 

## ERD Diagram

`Currently, the only version of the diagram is in Polish. Sorry for the inconvinience :)`

<img width="793" alt="The ERD diagram of the ICAO databse" src="https://github.com/taryesz/MOLC_database/assets/106448156/235f6030-cd08-41f4-83f1-ad95ddf078f0">

## RDB Schema

> _Hangary (<ins>ID_Hangaru</ins>, Kraj, Miasto, Właściciel *REF* Linie_Lotnicze)_

> _Linie_Lotnicze (<ins>ID_Linii</ins>, Nazwa, Kod_MULC, Kod_IATA)_

> _Zamówienia (<ins>ID_Zamówienia</ins>, Data, Miejsce_dostawy *REF* Hangary, Dostawca *REF* Firmy_Logistyczne, Zlecający *REF* Działy)_

> _Firmy_Logistyczne (<ins>ID_Firmy</ins>, Nazwa, Kraj)_

> _Pracownik_Samolotu (<ins>ID_Pracownika</ins>, Imię, Nazwisko, Stanowisko, Naczelnik *REF* Działy)_

> _Raporty (<ins>ID_Raportu</ins>, Data, Kod_awarii, Pojazd *REF* Samoloty, Przetwarzający *REF* Działy)_

> _Producenci (<ins>Nazwa</ins>, Numer_tel, Email, Strona_internetowa)_

> _Działy (<ins>ID_Działu</ins>, Nazwa, Numer_tel, Właściciel *REF* Linie_Lotnicze)_

> _Samoloty (<ins>NRS</ins>, Cena, Pojemność_pasażerska, Zasięg_lotu, Rozpiętość_skrzydeł, Długość, Stan, Dostępność, Model, Numer_zamówienia *REF* Zamówienia, Potencjalny_klient *REF* Działy, Producent *REF* Producenci)_

> _Logi (<ins>ID_Pracownika</ins> *REF* Pracownik_Samolotu, <ins>NRS</ins> *REF* Samoloty, Data)_

## Tech Stack

The only technology used in the database is **SQL** using **Microsoft SQL Server** DBMS

## Final remarks

**This is a university project**, not a real one. This database is not supposed to be used in real life (at least for now).

If you encounter any problems with it or want to contribute to the project, please, contact me: `hello.szulakiewicz@gmail.com`

