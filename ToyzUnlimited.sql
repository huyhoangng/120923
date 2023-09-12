Create database ToyzUnlimited
GO 
Use ToyzUnlimited
--Câu 1
create table Toy(
ProductCode int Primary key,
Name nvarchar(30) ,
Category nvarchar(30),
Manufacturer nvarchar(30),
AgeRange varchar(15),
UnitPrice money,
Netweight_gam int,
QtyOnHand int
);
Insert into Toy(ProductCode, Name, Category, Manufacturer, AgeRange, UnitPrice, Netweight_gam, QtyOnHand )
values (1,N'Xe dieu khien','dieu khien', 'Hotwheel','>5 years',$50,700,50),
(22,N'Xe mo hinh','mo hinh', 'Hotwheel','>5 years',$40,500,250),
(3,N'Robot','mo hinh', 'abc','>5 years',$50,500,450),
(5,N'Truc thang dieu khien','dieu khien', 'Hotwheel','>5 years',$80,1000,650),
(6,N'Bup be','mo hinh', 'xyz','>5 years',$35,300,50),
(10,N'Xe tang dieu khien','dieu khien', 'Hotwheel','>5 years',$65,800,850),
(11,N'Tau hoa','dien tu', 'Hotwheel','>5 years',$50,1000,5000),
(8,N'Bo cau ca','Bo do choi', 'dcb','>5 years',$45,500,500),
(9,N'Xe moto','mo hinh', 'Hotwheel','>5 years',$35,300,50)

SELECT *FROM Toy
GO
--Câu 2
CREATE PROCEDURE HeavyToys
AS
BEGIN
    SELECT *
    FROM Toy
    WHERE Netweight_gam > 500;
END;
EXEC HeavyToys;

--Câu 3
CREATE PROCEDURE sp_PriceIncrease
AS
BEGIN
    UPDATE Toy
    SET UnitPrice = UnitPrice + 10;
END;
EXEC sp_PriceIncrease;
GO
--Câu 4
CREATE PROCEDURE sp_QtyOnHand
AS
BEGIN
    UPDATE Toy
    SET QtyOnHand = QtyOnHand - 5;
END;
EXEC sp_QtyOnHand;
GO
--Câu 5 em để ở trong từng phần ạ 

--Phần 3
--Câu 1
sp_helptext HeavyToys
sp_helptext sp_PriceIncrease
sp_helptext sp_QtyOnHand

SELECT OBJECT_NAME(object_id) AS ProcedureName, definition
FROM sys.sql_modules
WHERE OBJECT_NAME(object_id) IN ('HeavyToys', 'sp_PriceIncrease', 'sp_QtyOnHand');


--Câu 2
sp_depends HeavyToys
sp_depends sp_PriceIncrease
sp_depends sp_QtyOnHand

--Câu 3
ALTER PROCEDURE sp_PriceIncrease
AS
BEGIN
    UPDATE Toy
    SET UnitPrice = UnitPrice + 10;

SELECT * FROM Toy;
END;

ALTER PROCEDURE sp_QtyOnHand
AS
BEGIN
    UPDATE Toy
    SET QtyOnHand = QtyOnHand - 5;

SELECT * FROM Toy;
END;
