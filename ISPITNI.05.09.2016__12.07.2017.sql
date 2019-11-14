--/* BAZE PODATAKA II – INTEGRALNI ISPIT */
--Mostar, 05.09.2016.
--1. Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea. U postupku kreiranja u obzir uzeti samo DEFAULT postavke.
--Unutar svoje baze podataka kreirati tabele sa sljedećom strukturom:
--a) Klijenti
--i. KlijentID, automatski generator vrijednosti i primarni ključ
--ii. Ime, polje za unos 30 UNICODE karaktera (obavezan unos)
--iii. Prezime, polje za unos 30 UNICODE karaktera (obavezan unos)
--iv. Telefon, polje za unos 20 UNICODE karaktera (obavezan unos)
--v. Mail, polje za unos 50 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
--vi. BrojRacuna, polje za unos 15 UNICODE karaktera (obavezan unos)
--vii. KorisnickoIme, polje za unos 20 UNICODE karaktera (obavezan unos)
--viii. Lozinka, polje za unos 20 UNICODE karaktera (obavezan unos)
--b) Transakcije
--i. TransakcijaID, automatski generator vrijednosti i primarni ključ
--ii. Datum, polje za unos datuma i vremena (obavezan unos)
--iii. TipTransakcije, polje za unos 30 UNICODE karaktera (obavezan unos)
--iv. PosiljalacID, referenca na tabelu Klijenti (obavezan unos)
--v. PrimalacID, referenca na tabelu Klijenti (obavezan unos)
--vi. Svrha, polje za unos 50 UNICODE karaktera (obavezan unos)
--vii. Iznos, polje za unos decimalnog broja (obavezan unos) 10 bodova
--2. Popunjavanje tabela podacima:
--a) Koristeći bazu podataka AdventureWorks2014, preko INSERT i SELECT komande importovati 10 kupaca u tabelu Klijenti. Ime, prezime, telefon, mail i broj računa (AccountNumber) preuzeti od kupca, korisničko ime generisati na osnovu imena i prezimena u formatu ime.prezime, a lozinku generisati na osnovu polja PasswordHash, i to uzeti samo zadnjih 8 karaktera.
--b) Putem jedne INSERT komande u tabelu Transakcije dodati minimalno 10 transakcija.
--10 bodova
--3. Kreiranje indeksa u bazi podataka nada tabelama:
--a) Non-clustered indeks nad tabelom Klijenti. Potrebno je indeksirati Ime i Prezime. Također, potrebno je uključiti kolonu BrojRacuna.
--b) Napisati proizvoljni upit nad tabelom Klijenti koji u potpunosti iskorištava indeks iz prethodnog koraka. Upit obavezno mora imati filter.
--c) Uraditi disable indeksa iz koraka a) 5 bodova
--4. Kreirati uskladištenu proceduru koja će vršiti upis novih klijenata. Kao parametre proslijediti sva polja. Provjeriti ispravnost kreirane procedure. 10 bodova
--5. Kreirati view sa sljedećom definicijom. Objekat treba da prikazuje datum transakcije, tip transakcije, ime i prezime pošiljaoca (spojeno), broj računa pošiljaoca, ime i prezime primaoca (spojeno), broj računa primaoca, svrhu i iznos transakcije.
--10 bodova
--6. Kreirati uskladištenu proceduru koja će na osnovu unesenog broja računa pošiljaoca prikazivati sve transakcije koje su provedene sa računa klijenta. U proceduri koristiti prethodno kreirani view. Provjeriti ispravnost kreirane procedure.
--10 bodova
--/* BAZE PODATAKA II – INTEGRALNI ISPIT */
--Mostar, 05.09.2016.
--7. Kreirati upit koji prikazuje sumaran iznos svih transakcija po godinama, sortirano po godinama. U rezultatu upita prikazati samo dvije kolone: kalendarska godina i ukupan iznos transakcija u godini.
--10 bodova
--8. Kreirati uskladištenu proceduru koje će vršiti brisanje klijenta uključujući sve njegove transakcije, bilo da je za transakciju vezan kao pošiljalac ili kao primalac. Provjeriti ispravnost kreirane procedure.
--10 bodova
--9. Kreirati uskladištenu proceduru koja će na osnovu unesenog broja računa ili prezimena pošiljaoca vršiti pretragu nad prethodno kreiranim view-om (zadatak 5). Testirati ispravnost procedure u sljedećim situacijama:
--a) Nije postavljena vrijednost niti jednom parametru (vraća sve zapise)
--b) Postavljena je vrijednost parametra broj računa,
--c) Postavljena je vrijednost parametra prezime,
--d) Postavljene su vrijednosti oba parametra.
--20 bodova
--10. Napraviti full i diferencijalni backup baze podataka na default lokaciju servera:
--a) C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Backup 5 bodova

CREATE DATABASE IB160267
GO

USE IB160267
GO


CREATE TABLE Klijenti
(
	KlijentID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_KlijentID PRIMARY KEY,
	Ime NVARCHAR(30)NOT NULL,
	Prezime NVARCHAR(30)NOT NULL,
	Telefon NVARCHAR(20)NOT NULL,
	Mail NVARCHAR(50)NOT NULL CONSTRAINT UQ_Klijenti_Mail UNIQUE,
	BrojRacuna NVARCHAR(15)NOT NULL,
	KorisnickoIme NVARCHAR(20)NOT NULL,
	Lozinka NVARCHAR(20)NOT NULL
);
GO

CREATE TABLE Transakcije
(
   TransakcijaID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_TransakcijaID PRIMARY KEY,
   Datum DATETIME NOT NULL,
   TipTransakcije NVARCHAR(30) NOT NULL,
   PosiljalacID INT NOT NULL CONSTRAINT FK_Transakcije_Klijent_PosiljalacID FOREIGN KEY REFERENCES Klijenti(KlijentID),
   PrimalacID INT NOT NULL CONSTRAINT FK_Transakcije_Klijent_PrimalacID FOREIGN KEY REFERENCES Klijenti(KlijentID),
   Svrha NVARCHAR(50) NOT NULL,
   Iznos DECIMAL (12,2) NOT NULL
)
GO


--2

INSERT INTO Klijenti
SELECT TOP 10 P.FirstName,P.LastName,PP.PhoneNumber,EA.EmailAddress,C.AccountNumber,P.FirstName+'.'+P.LastName,LEFT(PASS.PasswordHash,8)
FROM AdventureWorks2017.Person.Person AS P
     INNER JOIN AdventureWorks2017.Person.EmailAddress AS EA ON P.BusinessEntityID=EA.BusinessEntityID
	 INNER JOIN AdventureWorks2017.Person.PersonPhone AS PP ON P.BusinessEntityID=PP.BusinessEntityID
	 INNER JOIN AdventureWorks2017.Person.Password AS PASS ON P.BusinessEntityID=PASS.BusinessEntityID
	 INNER JOIN AdventureWorks2017.Sales.Customer AS C ON P.BusinessEntityID=C.PersonID
ORDER BY NEWID()
GO

SELECT *
FROM Klijenti
GO

INSERT INTO Transakcije
VALUES ('2016-01-01','TIP I',1,1,'Svrha 1',400),
       ('2016-02-02','TIP I',1,2,'Svrha 2',300),
	   ('2016-03-03','TIP II',2,1,'Svrha 3',200),
	   ('2015-04-04','TIP I',1,4,'Svrha 4',100),
	   ('2015-01-05','TIP II',2,3,'Svrha 5',500),
	   ('2015-05-06','TIP I',4,1,'Svrha 6',600),
	   ('2016-06-07','TIP I',5,2,'Svrha 7',700),
       ('2015-04-08','TIP II',3,1,'Svrha 8',800),
	   ('2017-03-09','TIP I',10,2,'Svrha 9',400),
	   ('2017-02-10','TIP II',9,4,'Svrha 10',300),
	   ('2017-01-11','TIP I',8,6,'Svrha 11',400),
	   ('2017-07-12','TIP II',7,1,'Svrha 12',800)
GO

--3

CREATE NONCLUSTERED INDEX IX_NON_Klijenti_Ime_Prezime_INC_BrojRacuna
ON Klijenti(Ime,Prezime)
INCLUDE (BrojRacuna)
GO

SELECT Ime,Prezime,BrojRacuna
FROM Klijenti
WHERE Prezime LIKE '[^A]%'
GO

ALTER INDEX IX_NON_Klijenti_Ime_Prezime_INC_BrojRacuna ON Klijenti
DISABLE
GO


--4


CREATE PROCEDURE usp_Klijent_INSERT
(
	@Ime NVARCHAR(30),
	@Prezime NVARCHAR(30),
	@Telefon NVARCHAR(20),
	@Mail NVARCHAR(50),
	@BrojRacuna NVARCHAR(15),
	@KorisnickoIme NVARCHAR(20),
	@Lozinka NVARCHAR(20)
)
AS
BEGIN
	INSERT INTO Klijenti
	VALUES (@Ime,@Prezime,@Telefon,@Mail,@BrojRacuna,@KorisnickoIme,@Lozinka)
END
GO

EXECUTE usp_Klijent_INSERT 'Miran','Raznatovic','061 010 021','mirnrazn@mail.com','123456918399311','Miran.Raznatovic','p@ssw0rt'
GO

SELECT *
FROM Klijenti
WHERE Mail ='mirnrazn@mail.com'
GO


--5

CREATE VIEW vTransakcijeKlijenti
AS
SELECT Datum,TipTransakcije,
       (SELECT Ime+' '+Prezime FROM Klijenti AS K WHERE K.KlijentID=PosiljalacID) AS Posiljaoc,
	   (SELECT BrojRacuna FROM Klijenti AS K WHERE K.KlijentID=PosiljalacID) AS [Racun posiljaoca],
	   (SELECT Ime+' '+Prezime FROM Klijenti AS K WHERE K.KlijentID=PrimalacID) AS Primalac,
	    (SELECT BrojRacuna FROM Klijenti AS K WHERE K.KlijentID=PrimalacID) AS [Racun primaoca],
	   Svrha,Iznos
FROM Transakcije
GO

--6

CREATE PROCEDURE usp_TransakcijePosiljaoca
(
@BrojRacuna NVARCHAR(15)
)
AS
BEGIN
	SELECT *
	FROM vTransakcijeKlijenti
	WHERE [Racun posiljaoca]=@BrojRacuna OR [Racun primaoca]=@BrojRacuna
END
GO

SELECT PosiljalacID
FROM Transakcije
GO

SELECT BrojRacuna
FROM Klijenti
WHERE KlijentID=2
GO


EXECUTE usp_TransakcijePosiljaoca 'AW00022634'
GO

--7


SELECT YEAR(Datum) AS Godina,CONVERT(NVARCHAR,SUM(Iznos))+' KM' AS [Ukupan iznos transakcija]
FROM Transakcije
GROUP BY YEAR(Datum)
GO

--8


CREATE PROCEDURE usp_Klijent_DELETE
(
@BrojRacuna NVARCHAR(15)
)
AS
BEGIN
   DELETE
   FROM Transakcije
   WHERE (PosiljalacID IN (SELECT KlijentID FROM Klijenti WHERE BrojRacuna=@BrojRacuna)) OR
         (PrimalacID IN (SELECT KlijentID FROM Klijenti WHERE BrojRacuna=@BrojRacuna))

	DELETE
	FROM Klijenti
	WHERE BrojRacuna=@BrojRacuna
END
GO


SELECT BrojRacuna
FROM Klijenti
WHERE KlijentID=2
GO

EXECUTE usp_Klijent_DELETE 'AW00022634'
GO

SELECT *
FROM Transakcije
WHERE (PosiljalacID IN (SELECT KlijentID FROM Klijenti WHERE BrojRacuna='AW00022634')) OR
      (PrimalacID IN (SELECT KlijentID FROM Klijenti WHERE BrojRacuna='AW00022634'))
GO

--9

CREATE PROCEDURE usp_KlijentTransakcije_SEARCH
(
	@BrojRacuna NVARCHAR(15)=NULL,
	@Prezime NVARCHAR(30)=NULL
)
AS
BEGIN
	SELECT *
	FROM vTransakcijeKlijenti
	WHERE ([Racun posiljaoca] =@BrojRacuna OR @BrojRacuna IS NULL)AND
		  (RIGHT(Posiljaoc,LEN(Posiljaoc)-CHARINDEX(' ',Posiljaoc)) LIKE @Prezime+'%' OR @Prezime IS NULL)
END
GO

SELECT Posiljaoc
FROM vTransakcijeKlijenti
GO


EXECUTE usp_KlijentTransakcije_SEARCH
GO

EXECUTE usp_KlijentTransakcije_SEARCH @BrojRacuna='AW00028302'
GO

EXECUTE usp_KlijentTransakcije_SEARCH @Prezime='Hughes'
GO

EXECUTE usp_KlijentTransakcije_SEARCH @BrojRacuna='AW00028302', @Prezime='Hughes'
GO


--10


BACKUP DATABASE IB160267
TO DISK = 'D:\Backup\IB160267.bak'
GO

BACKUP DATABASE IB160267
TO DISK='D:\Backup\IB160267DIFF.bak'
WITH DIFFERENTIAL
GO