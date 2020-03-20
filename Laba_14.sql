USE K_UNIVER
GO

DROP PROC PSUBJECT
-- TASK 1

CREATE PROC PSUBJECT AS
	BEGIN
	DECLARE @COUNT INT = ( SELECT COUNT( * ) FROM SUBJECT );
	SELECT
		SUBJECT.SUBJECT AS 'КОД',
		SUBJECT.SUBJECT_NAME AS 'НАЗВАНИЕ',
		SUBJECT.PULPIT AS 'КАФЕДРА'
	FROM SUBJECT;
	RETURN @COUNT;
	END
	GO

DECLARE @K INT;
EXEC @K = PSUBJECT
SELECT @K
GO
--  TASK 2

ALTER PROC PSUBJECT 
	@P VARCHAR(20) = NULL,
	@C INT OUTPUT AS
	BEGIN
		DECLARE @COUNT INT = ( SELECT COUNT( * ) FROM SUBJECT );
		SELECT
			SUBJECT.SUBJECT AS 'КОД',
			SUBJECT.SUBJECT_NAME AS 'НАЗВАНИЕ',
			SUBJECT.PULPIT AS 'КАФЕДРА'
		FROM SUBJECT
			WHERE SUBJECT.SUBJECT = @P;
		SET @C = @@ROWCOUNT;
		RETURN @COUNT;
	END;
GO

	DECLARE @K INT = 0, @R INT = 0, @P VARCHAR(20);
	EXEC @K = PSUBJECT @P = 'СУБД',@C = @R OUTPUT;
	PRINT @R 
	GO

	-- TASK 3
	ALTER PROC PSUBJECT @P VARCHAR(20) AS
		BEGIN
			DECLARE @K INT = ( SELECT COUNT( * ) FROM SUBJECT );
			SELECT * FROM SUBJECT WHERE SUBJECT.SUBJECT = @P;
		END;

	CREATE TABLE #TEMP(
		SUBJECT NVARCHAR(10) PRIMARY KEY,
		SUBJECT_NAME NVARCHAR(50),
		PULPIT NVARCHAR(50)
	)

	INSERT #TEMP EXEC PSUBJECT @P = 'СУБД'

	SELECT * FROM #TEMP
	GO
-- TASK 4
CREATE PROC PAUDITORIUM_INSERT
	@A CHAR(20),
	@N VARCHAR(50),
	@C INT = 0,
	@T CHAR(10) AS
	BEGIN
		DECLARE @RESULT INT = 1;
		BEGIN TRY
			INSERT INTO AUDITORIUM ( AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE )
				VALUES ( @A, @T, @C, @T )
			RETURN @RESULT;
		END TRY
		BEGIN CATCH
			PRINT ERROR_NUMBER();
			PRINT ERROR_MESSAGE();
			PRINT ERROR_SEVERITY();
			PRINT ERROR_LINE();
			IF ERROR_PROCEDURE() IS NOT NULL
				PRINT ERROR_PROCEDURE();
			RETURN -1;
		END CATCH
	END
GO

DECLARE @RESULT INT;
EXEC @RESULT = PAUDITORIUM_INSERT 'FGHJ','GFD',5,'DFDSA';
PRINT @RESULT
GO

-- TASK 5
CREATE PROC SUBJECT_REPORT 
	@P CHAR(10) AS 
	BEGIN
		DECLARE @RESULT INT = 0;
		BEGIN TRY
			DECLARE @TV CHAR(20), @T CHAR(300) = ' ';
			DECLARE SR cursor for
			SELECT SUBJECT.SUBJECT FROM SUBJECT WHERE SUBJECT.PULPIT = @P;
			IF NOT EXISTS ( SELECT SUBJECT.SUBJECT FROM SUBJECT WHERE SUBJECT.PULPIT = @P )
				RAISERROR ('ERR',22,2);
			ELSE 
				OPEN SR;
				FETCH SR INTO @TV;
				PRINT 'SUBJECT: ';
				WHILE @@FETCH_STATUS = 0
					BEGIN
						SET @T = RTRIM(@TV) + ', ' + @T;
						SET @RESULT = @RESULT + 1;
						FETCH SR INTO @TV;
					END
				PRINT @T;
				CLOSE SR;
				RETURN @RESULT;
		END TRY
		BEGIN CATCH
			PRINT 'ERR';
			IF ERROR_PROCEDURE() IS NOT NULL
				PRINT ERROR_PROCEDURE();
			RETURN @RESULT;
		END CATCH;
	END;


DECLARE @RC INT;
EXEC @RC = SUBJECT_REPORT @P = 'ИСиТ';
PRINT 'count= ' + CAST( @RC AS VARCHAR(3));
--error
GO
DECLARE @RC INT;
EXEC @RC = SUBJECT_REPORT @P='ИиТ';
PRINT 'count= ' + CAST( @RC AS VARCHAR(3));
GO


-- TASK 6
CREATE PROC PAUDITORIUM_INSERTX
	@A CHAR(20), @N VARCHAR(50), @C INT = NULL, @T CHAR(10)
	as 
	DECLARE @TN VARCHAR(50)
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;          
		BEGIN TRAN
			INSERT AUDITORIUM( AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME )
				VALUES ( @A, @N, @C, @T )
			EXEC @TN = PAUDITORIUM_INSERT @A, @N, @C, @T;
		COMMIT TRAN;
		RETURN @TN;
	END TRY
	BEGIN CATCH
		PRINT 'номер ошибки  : ' + cast(error_number() as varchar(6));
		PRINT 'сообщение     : ' + error_message();
		PRINT 'уровень       : ' + cast(error_severity()  as varchar(6));
		PRINT 'метка         : ' + cast(error_state()   as varchar(8));
		PRINT 'номер строки  : ' + cast(error_line()  as varchar(8));
		IF ERROR_PROCEDURE() IS NOT NULL
			PRINT ERROR_PROCEDURE()
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		RETURN -1;	  
	END CATCH;

go
DECLARE @TN INT;
EXEC @TN = PAUDITORIUM_INSERTX @A = '101-1', @N ='ИСиТ', @C = 50, @T = '101-1';
PRINT 'код ошибки=' + cast(@TN as varchar(3));  




USE [Laba_2.1]
GO
-- добавить клиента банка если клиент с  таким именем есть ошибка в output переменную вернуть наименование банка в return количество записей
DROP PROC DOP_1
CREATE PROC DOP_1
	@NAME NVARCHAR(25),
	@ID INT,
	@TYPE NVARCHAR(50),
	@ADDR NVARCHAR(50),
	@OUTPUT CHAR(10) OUTPUT AS
	BEGIN
		BEGIN TRY
			INSERT INTO Company ( company_id, name_company,  type_of_property, address )
				VALUES ( @ID, @NAME, @TYPE, @ADDR );
		END TRY
		BEGIN CATCH
			PRINT ERROR_NUMBER();
			PRINT ERROR_MESSAGE();
			PRINT ERROR_SEVERITY();
			PRINT ERROR_LINE();
			IF ERROR_PROCEDURE() IS NOT NULL
				PRINT ERROR_PROCEDURE();
		END CATCH
		SET @OUTPUT = 'NAME_BANK';
		RETURN ( SELECT COUNT(*) FROM Company )
	END
GO

DECLARE @OUT CHAR(10), @RET INT;
EXEC @RET = DOP_1 'L', 33, 'TYPE', 'ADDR', @OUTPUT = @OUT OUTPUT
PRINT 'RET ' + CAST( @RET AS VARCHAR(10));
PRINT 'OUT ' + @OUT;


-- вывести список крелитов взятых клиентами банка парметр имя клиента ( часть ) если это параметр null вывести всех если по шаблону  ничго вывести таких клиентов нет если клиенты  есть а у них нет кредитов то выввести 
GO
CREATE PROC DOP_2
	@NAME VARCHAR(50) = NULL AS 
	BEGIN
		IF ( @NAME IS NULL )
			BEGIN
				SELECT Company.name_company, Credit.name_type_of_credit, Delivery.summ
					FROM Delivery
						JOIN Company
							ON Company.company_id = Delivery.company_id
						JOIN Credit
							ON Credit.credit_id = Delivery.credit_id
			END
		ELSE IF ( ( SELECT COUNT(*) FROM Company
									JOIN Delivery
										ON Delivery.company_id = Company.company_id
								 WHERE Company.name_company LIKE ( '%' + @NAME + '%' ) ) > 0 )
			BEGIN
				SELECT Company.name_company, Credit.name_type_of_credit, Delivery.summ
					FROM Delivery
						JOIN Company
							ON Company.company_id = Delivery.company_id
						JOIN Credit
							ON Credit.credit_id = Delivery.credit_id
					WHERE Company.name_company LIKE ( '%' + @NAME + '%' );
			END
		ELSE IF (( SELECT COUNT(*) FROM Company WHERE Company.name_company LIKE ( '%' + @NAME + '%' ) ) = 0)
			BEGIN
				SELECT 'КЛИЕНТОВ С ИМЕНЕМ ' + @NAME + ' НЕ СУЩЕСТВУЕТ';
			END
		ELSE IF ( ( SELECT Company.company_id FROM Company
									WHERE Company.company_id NOT IN ( SELECT Company.company_id FROM Company
									JOIN Delivery
										ON Delivery.company_id = Company.company_id ) AND Company.name_company LIKE ( '%' + 'БНТУ' + '%' ) ) > 0 )
			BEGIN
				SELECT 'У КОМПАНИИ С ТАКИМ ИМЕНЕМ НЕТ КРЕДИТА'
			END
	END
GO

SELECT * FROM Company

EXEC DOP_2 'Л'

GO