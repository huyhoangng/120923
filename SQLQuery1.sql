Use AdventureWorks2022
Create procedure Display_Customers
AS Select CustomerID, AccountNumber, rowguid, ModifiedDate 
From Sales.Customer

EXECUTE Display_Customers

EXECUTE xp_fileexist 'C:\SQL2022\myText.txt'

EXECUTE sys.sp_who
GO

Create Procedure sp_DisplayEmployeesHireYear 
@HireYear int 
AS 
select * from HumanResources.Employee
Where DATEPART(YY, HireDate) = @HireYear 
GO 

--Tạo thủ tục lưu trữ đếm số người vào làm trong một năm xác định có tham số đầu vào là 1 năm,
--Tham số đầu ra là số người vào làm trong năm nay 
Create procedure sp_EmployeesHireYearCount 
@HireYear int, 
@Count int OUTPUT 
AS 
SELECT @Count=COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate)= @HireYear
GO

--tạo thủ tục lưu trữ đếm số người vào làm trong một năm xác định có tham số vào là 1 năm , hàm trả về số người vào làm năm đó 
Create procedure sp_EmployeesHireYearCount2
@HireYear int
AS
DECLARE @Count int 
Select @Count = Count(*) from HumanResources.Employee
WHERE DATEPART(YY, HireDate)= @HireYear
Return @Count 
GO 
--Chạy thủ tục lưu trữ cần phải truyền vào 1 tham số đầu và lấy về số người làm trong năm đó 
DECLARE @Number int 
EXECUTE @Number =  sp_EmployeesHireYearCount2 2022
Print @Number 
GO 

Create table #Students (
RollNo varchar(6) Constraint PK_Students Primary key ,
FullName nvarchar(100),
Birthday datetime constraint DF_StudentsBirthday DEFAULT 
DATEADD(yy, -18, GETDATE())
)
--Tạo thủ tục lưu trữ tạm để chèn dữ liệu vào bảng tạm 
Create procedure #spInsertStudents 
@rollNo varchar(6),
@fullName nvarchar(100),
@birthday datetime 
AS Begin 
IF (@birthday is null)
SET @birthday=DATEADD(YY, -18, GETDATE())
INSERT INTO #Students(RollNo, FullName, Birthday)
VALUES(@rollNo, @fullName, @birthday)
END
GO
--Sử dụng thủ tục lữu trữ để chèn dữ liệu vào bảng tạm 
EXEC #spInsertStudents 'A12345','abc', null 
EXEC #spInsertStudents 'A54321','abc', '12/20/2011'
Select * from #Students

--Tạo thủ tục lưu trữ tạm để xoá dữ liệu từ bảng tạm theo RollNo 
Create procedure #spDeleteStudents 
@rollNo varchar(6)
AS Begin 
DELETE from #Students where RollNo =  @rollNo
END 

EXECUTE #spDeleteStudents 'A12345'
GO 
--Tạo một thủ tục lưu trữ sử dung lệnh RETURN để trả về một số nguyên
CREATE PROCEDURE Cal_Square @num int=0 
AS
BEGIN 
RETURN (@num * @num);
END 
GO 
--Chạy thủ tục lưu trữ 
DECLARE @square int ;
EXEC @square = Cal_Square 10;
PRINT @square ;
GO 

Select 
OBJECT_DEFINITION(OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')) 
AS DEFINITION

select definition from sys.sql_modules
where 
object_id= OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')
GO 

--Thủ tục lưu trữ hệ thống xem các thành phần mà thủ tục lưu trữ phụ thuộc
sp_depends 'HumanResources.uspUpdateEmployeePersonalInfo'
GO

USE AdventureWorks2022
GO

CREATE PROCEDURE sp_DisplayEmployees AS
SELECT * FROM HumanResources.Employee
GO
ALTER PROCEDURE sp_DisplayEmployees AS
SELECT * FROM HumanResources.Employee
WHERE Gender='F'
GO
EXEC sp_DisplayEmployees
GO
DROP PROCEDURE sp_DisplayEmployees
GO


CREATE PROCEDURE sp_EmployeeHire
AS
BEGIN
--Hiển thị
EXECUTE sp_DisplayEmployeesHireYear 1999
DECLARE @Number int
EXECUTE sp_EmployeesHireYearCount 1999, @Number OUTPUT
PRINT N'Số nhân viên vào làm năm 1999 là: ' +
CONVERT(varchar(3),@Number)
END
GO
--Chạy thủ tục lưu trữ
EXEC sp_EmployeeHire
GO
ALTER PROCEDURE sp_EmployeeHire
@HireYear int
AS
BEGIN
BEGIN TRY
EXECUTE sp_DisplayEmployeesHireYear @HireYear
DECLARE @Number int
EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT, '123'
--Lỗi xảy ra ở đây có thủ tục sp_EmployeesHireYearCount chỉ truyền 2 tham số mà ta truyền 3
PRINT N'Số nhân viên vào làm năm là: ' +
CONVERT(varchar(3),@Number)
END TRY
BEGIN CATCH
PRINT N'Có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
END CATCH
PRINT N'Kết thúc thủ tục lưu trữ'
END
GO
--Chạy thủ tục sp_EmployeeHire
EXEC sp_EmployeeHire 1999
GO
--Xem thông báo lỗi bên Messages không phải bên Result


ALTER PROCEDURE sp_EmployeeHire
@HireYear int
AS
BEGIN
EXECUTE sp_DisplayEmployeesHireYear @HireYear
DECLARE @Number int
EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT, '123'
IF @@ERROR <> 0
PRINT N'Có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
PRINT N'Số nhân viên vào làm năm là: ' +
CONVERT(varchar(3),@Number)
END
GO
EXEC sp_EmployeeHire 1999