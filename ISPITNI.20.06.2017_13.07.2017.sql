--1.	Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea. Fajlove baze podataka smjestiti na sljedeće lokacije:
--a)	Data fajl: D:\BP2\Data
--b)	Log fajl: D:\BP2\Log								5 bodova

--2.	U svojoj bazi podataka kreirati tabele sa sljedećom strukturom:
--a)	Proizvodi
--i.	ProizvodID, cjelobrojna vrijednost i primarni ključ
--ii.	Sifra, polje za unos 25 UNICODE karaktera (jedinstvena vrijednost i obavezan unos)
--iii.	Naziv, polje za unos 50 UNICODE karaktera (obavezan unos)
--iv.	Kategorija, polje za unos 50 UNICODE karaktera (obavezan unos)
--v.	Cijena, polje za unos decimalnog broja (obavezan unos)
--b)	Narudzbe
--i.	NarudzbaID, cjelobrojna vrijednost i primarni ključ,
--ii.	BrojNarudzbe, polje za unos 25 UNICODE karaktera (jedinstvena vrijednost i obavezan unos)
--iii.	Datum, polje za unos datuma (obavezan unos),
--iv.	Ukupno, polje za unos decimalnog broja (obavezan unos)
--c)	StavkeNarudzbe
--i.	ProizvodID, cjelobrojna vrijednost i dio primarnog ključa,
--ii.	NarudzbaID, cjelobrojna vrijednost i dio primarnog ključa,
--iii.	Kolicina, cjelobrojna vrijednost (obavezan unos)
--iv.	Cijena, polje za unos decimalnog broja (obavezan unos)
--v.	Popust, polje za unos decimalnog broja (obavezan unos)
--vi.	Iznos, polje za unos decimalnog broja (obavezan unos)
--10 bodova
--3.	Iz baze podataka AdventureWorks2014 u svoju bazu podataka prebaciti sljedeće podatke:
--a)	U tabelu Proizvodi dodati sve proizvode koji su prodavani u 2014. godini
--i.	ProductNumber -> Sifra
--ii.	Name -> Naziv
--iii.	ProductCategory (Name) -> Kategorija
--iv.	ListPrice -> Cijena
--b)	U tabelu Narudzbe dodati sve narudžbe obavljene u 2014. godini
--i.	SalesOrderNumber -> BrojNarudzbe
--ii.	OrderDate - > Datum
--iii.	TotalDue -> Ukupno
--c)	U tabelu StavkeNarudzbe prebaciti sve podatke o detaljima narudžbi urađenih u 2014. godini
--i.	OrderQty -> Kolicina
--ii.	UnitPrice -> Cijena
--iii.	UnitPriceDiscount -> Popust
--iv.	LineTotal -> Iznos 
--	Napomena: Zadržati identifikatore zapisa!							20 bodova

--4.	U svojoj bazi podataka kreirati novu tabelu Skladista sa poljima SkladisteID i Naziv, a zatim je povezati sa tabelom Proizvodi u relaciji više prema više. Za svaki proizvod na skladištu je potrebno čuvati količinu (cjelobrojna vrijednost).	 																				5 bodova
--5.	U tabelu Skladista  dodati tri skladišta proizvoljno, a zatim za sve proizvode na svim skladištima postaviti količinu na 0 komada.
--5 bodova
--6.	Kreirati uskladištenu proceduru koja vrši izmjenu stanja skladišta (količina). Kao parametre proceduri proslijediti identifikatore proizvoda i skladišta, te količinu.						10 bodova



--7.	Nad tabelom Proizvodi kreirati non-clustered indeks nad poljima Sifra i Naziv, a zatim napisati proizvoljni upit koji u potpunosti iskorištava kreirani indeks. Upit obavezno mora sadržavati filtriranje podataka.
--										5 bodova

--8.	Kreirati trigger koji će spriječiti brisanje zapisa u tabeli Proizvodi.	 			5 bodova

--9.	Kreirati view koji prikazuje sljedeće kolone: šifru, naziv i cijenu proizvoda, ukupnu prodanu količinu i ukupnu zaradu od prodaje.									10 bodova

--10.	Kreirati uskladištenu proceduru koja će za unesenu šifru proizvoda prikazivati ukupnu prodanu količinu i ukupnu zaradu. Ukoliko se ne unese šifra proizvoda procedura treba da prikaže prodaju svih proizovda. U proceduri koristiti prethodno kreirani view.								10 bodova

--11.	U svojoj bazi podataka kreirati novog korisnika za login student te mu dodijeliti odgovarajuću permisiju kako bi mogao izvršavati prethodno kreiranu proceduru.
--10 bodova
--12.	Napraviti full i diferencijalni backup baze podataka na lokaciji D:\BP2\Backup	 														5 bodova


CREATE DATABASE IB160267
ON
(NAME='Data',FILENAME='D:\BP2\IB160267\Data')
LOG ON
(NAME ='Log',FILENAME='D:\BP2\IB160267\LOG')
GO

USE IB160267
GO


CREATE TABLE Proizvodi
(
	 ProizvodID INT NOT NULL IDENTITY (1,1) CONSTRAINT PK_ProizvodID PRIMARY KEY,
	 Sifra NVARCHAR(25) NOT NULL CONSTRAINT UQ_Proizvodi_Sifra UNIQUE,
	 Naziv NVARCHAR(50) NOT NULL,
	 Kategorija NVARCHAR(50) NOT NULL,
	 Cijena DECIMAL (10,2) NOT NULL
);
GO

CREATE TABLE Narudzbe
(
	 NarudzbaID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_NarudzbaID PRIMARY KEY,
	 BrojNarudzbe NVARCHAR(25) NOT NULL CONSTRAINT UQ_Narudzbe_BrojNarudzbe UNIQUE,
	 Datum DATE NOT NULL,
	 Ukupno DECIMAL(15,2) NOT NULL
);
GO

CREATE TABLE StavkeNarudzbe
(
	 ProizvodID INT NOT NULL  CONSTRAINT FK_StavkeNarudzbe_ProizvodID FOREIGN KEY REFERENCES Proizvodi(ProizvodID),
	 NarudzbaID INT NOT NULL  CONSTRAINT FK_StavkeNarudzbe_NarudzbaID FOREIGN KEY REFERENCES Narudzbe(NarudzbaID),
	 CONSTRAINT PK_StavkeNarudzbe_ProizvodID_NarudzbaID PRIMARY KEY(ProizvodID,NarudzbaID),
	 Kolicina INT NOT NULL,
	 Cijena DECIMAL(10,2) NOT NULL,
	 Popust DECIMAL(10,2) NOT NULL,
	 Iznos DECIMAL(15,2) NOT NULL
);
GO

--2

SET IDENTITY_INSERT Proizvodi ON
INSERT INTO Proizvodi (ProizvodID,Sifra,Naziv,Kategorija,Cijena)
SELECT DISTINCT P.ProductID,P.ProductNumber,P.Name,PC.Name,P.ListPrice
FROM AdventureWorks2017.Production.Product AS P
     INNER JOIN AdventureWorks2017.Production.ProductSubcategory AS PS ON P.ProductSubcategoryID=PS.ProductSubcategoryID
	 INNER JOIN AdventureWorks2017.Production.ProductCategory AS PC ON PS.ProductCategoryID=PC.ProductCategoryID
     INNER JOIN AdventureWorks2017.Sales.SalesOrderDetail AS SOD ON P.ProductID=SOD.ProductID
	  INNER JOIN AdventureWorks2017.Sales.SalesOrderHeader AS SOH ON SOD.SalesOrderID=SOH.SalesOrderID 
WHERE YEAR(SOH.OrderDate)=2014
SET IDENTITY_INSERT Proizvodi OFF	
GO

SET IDENTITY_INSERT Narudzbe ON	
INSERT INTO Narudzbe(NarudzbaID,BrojNarudzbe,Datum,Ukupno) 
SELECT DISTINCT SOH.SalesOrderID,SOH.SalesOrderNumber,SOH.OrderDate,SOH.TotalDue
FROM AdventureWorks2017.Sales.SalesOrderDetail AS SOD
     INNER JOIN AdventureWorks2017.Sales.SalesOrderHeader AS SOH ON SOD.SalesOrderID=SOH.SalesOrderID
WHERE YEAR(SOH.OrderDate)=2014
SET IDENTITY_INSERT Narudzbe OFF
GO


INSERT INTO StavkeNarudzbe
SELECT P.ProductID,SOH.SalesOrderID,SOD.OrderQty,SOD.UnitPrice,SOD.UnitPriceDiscount,SOD.LineTotal
FROM AdventureWorks2017.Sales.SalesOrderDetail AS SOD
     INNER JOIN AdventureWorks2017.Sales.SalesOrderHeader AS SOH ON SOD.SalesOrderID=SOH.SalesOrderID
     INNER JOIN AdventureWorks2017.Production.Product AS P ON SOD.ProductID=P.ProductID
WHERE YEAR(SOH.OrderDate)=2014
GO


--3


CREATE TABLE Skladiste
(
	SkladisteID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_SkladisteID PRIMARY KEY,
	Naziv NVARCHAR (30) NOT NULL
);
GO


CREATE TABLE ProizvodSkladiste
(
  SkladisteID INT NOT NULL CONSTRAINT FK_ProizvodSkladiste_SkladisteID FOREIGN KEY REFERENCES Skladiste(SkladisteID),
  ProizvodID INT NOT NULL CONSTRAINT FK_ProizvodSkladiste_ProizvodID FOREIGN KEY REFERENCES Proizvodi(ProizvodID),
  CONSTRAINT PK_ProizvodSkladiste_SkladisteID_ProizvodID PRIMARY KEY(SkladisteID,ProizvodID),
  Kolicina INT NOT NULL
);
GO

--4

INSERT INTO Skladiste
VALUES ('Mostarsko'),
       ('Sarajevosko'),
	   ('Zenicko')
GO

INSERT INTO ProizvodSkladiste
SELECT 1,ProizvodID,0 FROM Proizvodi
GO

INSERT INTO ProizvodSkladiste
SELECT 2,ProizvodID,0 FROM Proizvodi
GO

INSERT INTO ProizvodSkladiste
SELECT 3,ProizvodID,0 FROM Proizvodi
GO

SELECT *
FROM ProizvodSkladiste
GO


--5


CREATE PROCEDURE usp_ProizvodSkladiste_UPDATE
(
	@ProizvodID INT,
	@SkladisteID INT,
	@Kolicina INT
)
AS
BEGIN
	UPDATE ProizvodSkladiste
	SET Kolicina+=@Kolicina
	WHERE ProizvodID=@ProizvodID AND SkladisteID=@SkladisteID
END
GO

SELECT TOP 5 ProizvodID
FROM Proizvodi
GO

EXECUTE usp_ProizvodSkladiste_UPDATE 872,1,30
GO

SELECT *
FROM ProizvodSkladiste
WHERE ProizvodID=872 AND SkladisteID=1
GO


--6


CREATE NONCLUSTERED INDEX IX_NON_Proizvodi_Sifra_Naziv
ON Proizvodi(Sifra,Naziv)
GO

SELECT Sifra,Naziv
FROM Proizvodi
WHERE Naziv LIKE '[^M]%'
GO

--7

CREATE TRIGGER tr_Proizvodi_INSTEAD_DELETE
 ON Proizvodi
 INSTEAD OF DELETE
 AS
 BEGIN
	 print 'Nije moguce brisati podatke iz tabele Proizvodi'
	 ROLLBACK TRANSACTION
 END
 GO

 DELETE
 FROM Proizvodi
 WHERE Naziv LIKE '[M]%'
 GO
 --8

 CREATE VIEW vProizvodiStavkeNarudzbe
 AS
 SELECT P.Sifra,P.Naziv,P.Cijena,SUM(SN.Kolicina) AS Kolicina,SUM(N.Ukupno) AS Zarada
 FROM Proizvodi AS P
      INNER JOIN StavkeNarudzbe AS SN ON P.ProizvodID=SN.ProizvodID
	  INNER JOIN Narudzbe AS N ON SN.NarudzbaID=N.NarudzbaID
GROUP BY P.Sifra,P.Naziv,P.Cijena
GO

SELECT *
FROM vProizvodiStavkeNarudzbe
ORDER BY Kolicina DESC
GO

--9

CREATE PROCEDURE usp_ProizvodiStavke_SEARCH
(
  @Sifra NVARCHAR(25)=NULL
)
AS
BEGIN
	SELECT Kolicina,Zarada
	FROM vProizvodiStavkeNarudzbe
	WHERE Sifra=@Sifra OR @Sifra IS NULL
END
GO

EXECUTE usp_ProizvodiStavke_SEARCH
GO

EXECUTE usp_ProizvodiStavke_SEARCH 'HL-U509-R'
GO

--10

CREATE USER IB160267 FOR LOGIN Student
GO

GRANT EXECUTE ON [dbo].[usp_ProizvodiStavke_SEARCH] TO IB160267
GO
--11

BACKUP DATABASE IB160267
TO DISK ='D:\Backup\IB160267.bak'
GO

BACKUP DATABASE IB160267
TO DISK ='D:\Backup\IB160267DIFF.bak'
WITH DIFFERENTIAL
GO