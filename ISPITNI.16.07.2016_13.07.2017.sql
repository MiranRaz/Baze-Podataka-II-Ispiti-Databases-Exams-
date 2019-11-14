--/* BAZE PODATAKA II – INTEGRALNI ISPIT */
--1. Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea. U postupku kreiranja u obzir uzeti samo DEFAULT postavke.
--Unutar svoje baze podataka kreirati tabelu sa sljedećom strukturom:
--a) Proizvodi:
--I. ProizvodID, automatski generatpr vrijednosti i primarni ključ
--II. Sifra, polje za unos 10 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
--III. Naziv, polje za unos 50 UNICODE karaktera (obavezan unos)
--IV. Cijena, polje za unos decimalnog broja (obavezan unos)
--b) Skladista
--I. SkladisteID, automatski generator vrijednosti i primarni ključ
--II. Naziv, polje za unos 50 UNICODE karaktera (obavezan unos)
--III. Oznaka, polje za unos 10 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
--IV. Lokacija, polje za unos 50 UNICODE karaktera (obavezan unos)
--c) SkladisteProizvodi
--I) Stanje, polje za unos decimalnih brojeva (obavezan unos)
--Napomena: Na jednom skladištu može biti uskladišteno više proizvoda, dok isti proizvod može biti uskladišten na više različitih skladišta. Onemogućiti da se isti proizvod na skladištu može pojaviti više puta.
--10 bodova
--2. Popunjavanje tabela podacima
--a) Putem INSERT komande u tabelu Skladista dodati minimalno 3 skladišta.
--b) Koristeći bazu podataka AdventureWorks2014, preko INSERT i SELECT komande importovati 10 najprodavanijih bicikala (kategorija proizvoda 'Bikes' i to sljedeće kolone:
--I. Broj proizvoda (ProductNumber) - > Sifra,
--II. Naziv bicikla (Name) -> Naziv,
--III. Cijena po komadu (ListPrice) -> Cijena,
--c) Putem INSERT i SELECT komandi u tabelu SkladisteProizvodi za sva dodana skladista importovati sve proizvode tako da stanje bude 100
--10 bodova
--3. Kreirati uskladištenu proceduru koja će vršiti povećanje stanja skladišta za određeni proizvod na odabranom skladištu. Provjeriti ispravnost procedure.
--10 bodova
--4. Kreiranje indeksa u bazi podataka nad tabelama
--a) Non-clustered indeks nad tabelom Proizvodi. Potrebno je indeksirati Sifru i Naziv. Također, potrebno je uključiti kolonu Cijena
--b) Napisati proizvoljni upit nad tabelom Proizvodi koji u potpunosti iskorištava indeks iz prethodnog koraka
--c) Uradite disable indeksa iz koraka a)
--5 bodova
--5. Kreirati view sa sljedećom definicijom. Objekat treba da prikazuje sifru, naziv i cijenu proizvoda, oznaku, naziv i lokaciju skladišta, te stanje na skladištu.
--10 bodova
--6. Kreirati uskladištenu proceduru koja će na osnovu unesene šifre proizvoda prikazati ukupno stanje zaliha na svim skladištima. U rezultatu prikazati sifru, naziv i cijenu proizvoda te ukupno stanje zaliha. U proceduri koristiti prethodno kreirani view. Provjeriti ispravnost kreirane procedure.
--10 bodova
--7. Kreirati uskladištenu proceduru koja će vršiti upis novih proizvoda, te kao stanje zaliha za uneseni proizvod postaviti na 0 za sva skladišta. Provjeriti ispravnost kreirane procedure.
--10 bodova
--8. Kreirati uskladištenu proceduru koja će za unesenu šifru proizvoda vršiti brisanje proizvoda uključujući stanje na svim skladištima. Provjeriti ispravnost procedure.
--10 bodova
--9. Kreirati uskladištenu proceduru koja će za unesenu šifru proizvoda, oznaku skladišta ili lokaciju skladišta vršiti pretragu prethodno kreiranim view-om (zadatak 5). Procedura obavezno treba da vraća rezultate bez obrzira da li su vrijednosti parametara postavljene. Testirati ispravnost procedure u sljedećim situacijama:
--a) Nije postavljena vrijednost niti jednom parametru (vraća sve zapise)
--b) Postavljena je vrijednost parametra šifra proizvoda, a ostala dva parametra nisu
--c) Postavljene su vrijednosti parametra šifra proizvoda i oznaka skladišta, a lokacija nije
--d) Postavljene su vrijednosti parametara šifre proizvoda i lokacije, a oznaka skladišta nije
--e) Postavljene su vrijednosti sva tri parametra
--20 bodova
--10. Napraviti full i diferencijalni backup baze podataka na default lokaciju servera:
--C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Backup
--5 bodova


CREATE DATABASE IB160267
GO

USE IB160267
GO


--1

CREATE TABLE Proizvodi
(
	 ProizvodID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_ProizvodID PRIMARY KEY,
	 Sifra NVARCHAR(10) NOT NULL CONSTRAINT UQ_Prizvodi_Sifra UNIQUE,
	 Naziv NVARCHAR(50) NOT NULL,
	 Cijena DECIMAL (10,2)NOT NULL
);
GO

CREATE TABLE Skladista
(
	 SkladisteID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_SkladisteID PRIMARY KEY,
	 Naziv NVARCHAR (50) NOT NULL,
	 Oznaka NVARCHAR (10) NOT NULL CONSTRAINT UQ_Skladiste_Oznaka UNIQUE,
	 Lokacija NVARCHAR (50) NOT NULL
);
GO

CREATE TABLE SkladisteProizvoda
(
	ProizvodID INT NOT NULL CONSTRAINT FK_SkladisteProizvoda_ProizvodID FOREIGN KEY REFERENCES Proizvodi(ProizvodID),
	SkladisteID INT NOT NULL CONSTRAINT FK_SkladisteProizvoda_SkladisteID FOREIGN KEY REFERENCES Skladista(SkladisteID),
	CONSTRAINT PK_SkladisteProizvoda_ProizvodID_SkladisteID PRIMARY KEY(ProizvodID,SkladisteID),
	Stanje DECIMAL (8,2)NOT NULL
);
GO

--2

--a)
INSERT INTO Skladista
VALUES ('Mostarsko','MO','Mostar'),
       ('Sarajevsko','SA','Sarajevo'),
	   ('Zenicko','ZE','Zenica')
GO

--b)

INSERT INTO Proizvodi
SELECT T.ProductNumber,T.Name,T.ListPrice
FROM(SELECT TOP 10 P.ProductNumber,P.Name,P.ListPrice,(SELECT SUM(OrderQty) FROM AdventureWorks2017.Sales.SalesOrderDetail AS SOD WHERE SOD.ProductID=P.ProductID) AS Kolicina
FROM AdventureWorks2017.Production.Product AS P
     INNER JOIN AdventureWorks2017.Production.ProductSubcategory AS PS ON P.ProductSubcategoryID=PS.ProductSubcategoryID
	 INNER JOIN AdventureWorks2017.Production.ProductCategory AS PC ON PS.ProductCategoryID=PS.ProductCategoryID
WHERE PC.Name ='Bikes'
ORDER BY Kolicina DESC)AS T
GO

--c)

INSERT INTO SkladisteProizvoda
SELECT ProizvodID,1,100 FROM Proizvodi
GO

INSERT INTO SkladisteProizvoda
SELECT ProizvodID,2,100 FROM Proizvodi
GO

INSERT INTO SkladisteProizvoda
SELECT ProizvodID,3,100 FROM Proizvodi
GO

SELECT *
FROM SkladisteProizvoda
GO


--3


CREATE PROCEDURE usp_SkladisteProizvodi_UPDATE
(
	@ProizvodID INT,
	@SkladisteID INT,
	@Stanje DECIMAL(8,2)
)
AS
BEGIN
	UPDATE SkladisteProizvoda
	SET Stanje+=@Stanje
	WHERE ProizvodID=@ProizvodID AND SkladisteID=@SkladisteID
END
GO

EXECUTE usp_SkladisteProizvodi_UPDATE 1,1,-20
GO

SELECT *
FROM SkladisteProizvoda
WHERE ProizvodID=1 AND SkladisteID=1
GO

--4

--a)
CREATE NONCLUSTERED INDEX IX_NON_Proizvodi_Sifra_Naziv_INC_Cijena
ON Proizvodi(Sifra,Naziv)
INCLUDE (Cijena)
GO

--b)
SELECT Sifra,Naziv,Cijena
FROM Proizvodi
WHERE Naziv LIKE '[^A]%'
GO

--c)
ALTER INDEX IX_NON_Proizvodi_Sifra_Naziv_INC_Cijena ON Proizvodi
DISABLE
GO


--5

CREATE VIEW vSkladisteProizvodi
AS
SELECT P.Sifra,P.Naziv AS Proizvod,P.Cijena,S.Oznaka,S.Naziv,S.Lokacija,SP.Stanje
FROM Proizvodi AS P
     INNER JOIN SkladisteProizvoda AS SP ON P.ProizvodID=SP.ProizvodID
	 INNER JOIN Skladista AS S ON SP.SkladisteID=S.SkladisteID
GO

SELECT *
FROM vSkladisteProizvodi
GO

--6

CREATE PROCEDURE usp_vSkladisteProizvodi_Stanje_SEARCH
(
  @Sifra NVARCHAR(10)
)
AS
BEGIN
	SELECT Sifra,Proizvod,Cijena, SUM(Stanje) AS [Ukupno stanje]
	FROM vSkladisteProizvodi
	WHERE Sifra=@Sifra
	GROUP BY Sifra,Proizvod,Cijena
END
GO

SELECT DISTINCT Sifra
FROM vSkladisteProizvodi
GO

EXECUTE usp_vSkladisteProizvodi_Stanje_SEARCH 'HL-U509-B'
GO

--7

CREATE PROCEDURE usp_Proizvodi_INSERT
(
	@Sifra NVARCHAR(10),
	@Naziv NVARCHAR(50),
	@Cijena DECIMAL (10,2)
)
AS
BEGIN
	INSERT INTO Proizvodi
	VALUES (@Sifra,@Naziv,@Cijena)

	DECLARE @ProizvodID INT
	SET @ProizvodID=@@IDENTITY

	INSERT INTO SkladisteProizvoda
	SELECT @ProizvodID,SkladisteID,0 FROM Skladista

END
GO

EXECUTE usp_Proizvodi_INSERT 'AABMFKR','BMX',2500
GO

SELECT *
FROM SkladisteProizvoda
WHERE ProizvodID = (SELECT ProizvodID FROM Proizvodi WHERE Naziv='BMX')
GO


--8


CREATE PROCEDURE usp_Proizvodi_DELETE
(
@Sifra NVARCHAR(10)
)
AS
BEGIN

	 DELETE 
	 FROM SkladisteProizvoda
	 WHERE ProizvodID IN (SELECT ProizvodID FROM Proizvodi WHERE Sifra=@Sifra)
  
	 DELETE
	 FROM Proizvodi
	 WHERE Sifra=@Sifra

END
GO

SELECT Sifra
FROM Proizvodi
WHERE ProizvodID=11
GO

EXECUTE usp_Proizvodi_DELETE 'AABMFKR'
GO

SELECT *
FROM SkladisteProizvoda
WHERE ProizvodID IN (SELECT ProizvodID FROM Proizvodi WHERE Sifra='AABMFKR')
GO


--9


CREATE PROCEDURE usp_vProizvodiSkladiste_SEARCH
(
@Sifra NVARCHAR(10)=NULL,
@Oznaka NVARCHAR(10)=NULL,
@Lokacija NVARCHAR(50)=NULL
)
AS
BEGIN
SELECT *
FROM vSkladisteProizvodi
WHERE (Sifra=@Sifra OR @Sifra IS NULL) AND
       (Oznaka=@Oznaka OR @Oznaka IS NULL)AND
	   (Lokacija=@Lokacija OR @Lokacija IS NULL)
END
GO


--a) Nije postavljena vrijednost niti jednom parametru (vraæa sve zapise)

    EXECUTE usp_vProizvodiSkladiste_SEARCH
	GO

--b) Postavljena je vrijednost parametra šifra proizvoda, a ostala dva parametra nisu

  EXECUTE usp_vProizvodiSkladiste_SEARCH 'CA-1098'
	GO

--c) Postavljene su vrijednosti parametra šifra proizvoda i oznaka skladišta, a lokacija nije

 EXECUTE usp_vProizvodiSkladiste_SEARCH @Sifra='CA-1098',@Oznaka='MO'
	GO

--d) Postavljene su vrijednosti parametara šifre proizvoda i lokacije, a oznaka skladišta nije

 EXECUTE usp_vProizvodiSkladiste_SEARCH @Sifra='CA-1098',@Lokacija='Mostar'
	GO

--e) Postavljene su vrijednosti sva tri parametra

 EXECUTE usp_vProizvodiSkladiste_SEARCH @Sifra='CA-1098',@Oznaka='MO',@Lokacija='Mostar'
	GO



--10

BACKUP DATABASE IB160267
TO DISK = 'D:\Backup\IB160267.bak'
GO



BACKUP DATABASE IB160267
TO DISK ='D:\Backup\IB160267DIFF.bak'
WITH DIFFERENTIAL
GO
