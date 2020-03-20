-- 1
USE H_MyBase
GO

DECLARE @VAR_1 CHAR(3) = 'somestring', @VAR_2 VARCHAR(3) = 'somestring2',
	@VAR_3 DATETIME, @VAR_4 TIME,
	@VAR_5 SMALLINT, @VAR_6 INT,
	@VAR_7 TINYINT, @VAR_8 NUMERIC(12,5);
SET @VAR_3 = ( SELECT MAX(Товары.Цена) FROM Товары );
SET @VAR_4 =  CONVERT( TIME, GETDATE() );

SELECT @VAR_6 = MAX( Заказы.Количество ),
			 @VAR_7 = COUNT( Заказы.Количество ),
			 @VAR_8 = ROUND( PI() * AVG( Заказы.Количество ), 5 ) 
			 FROM Товары, Заказы
				WHERE Товары.ID_Товара = Заказы.ID_Товара;

SELECT @VAR_1, @VAR_2,
			 @VAR_3, @VAR_4;

PRINT CAST( @VAR_5 AS VARCHAR(15) );
PRINT CAST( @VAR_6 AS VARCHAR(15) );
PRINT CAST( @VAR_7 AS VARCHAR(15) );
PRINT CAST( @VAR_8 AS VARCHAR(15) );
GO

-- 2
USE K_UNIVER;
GO

DECLARE @_ALL_CAPACITY INT = 
	( SELECT SUM( AUDITORIUM.AUDITORIUM_CAPACITY )
			FROM AUDITORIUM ),
				@_COUNT INT,
				@_AVG_CAPACITY NUMERIC(8,3),
				@_COUNT_2 INT,
				@_KOEF NUMERIC(8,3);

IF @_ALL_CAPACITY > 200
	BEGIN
		SET @_COUNT = ( SELECT COUNT(*) FROM AUDITORIUM );
		SET @_AVG_CAPACITY = ( SELECT CAST(AVG( AUDITORIUM.AUDITORIUM_CAPACITY ) AS NUMERIC(8,3)) FROM AUDITORIUM );
		SET @_COUNT_2 = ( SELECT COUNT( * ) FROM AUDITORIUM
												WHERE AUDITORIUM_CAPACITY < @_AVG_CAPACITY );
		SET @_KOEF = CAST(( @_COUNT_2 / @_COUNT ) AS NUMERIC(8,3));  
		SELECT @_COUNT, @_AVG_CAPACITY,
					 @_COUNT_2, @_KOEF;
	END
ELSE 
	BEGIN 
		PRINT 'ОбЩАЯ ВМЕСТИМОСТЬ ' + CAST( @_ALL_CAPACITY AS VARCHAR(15) );
	END;
GO

-- 3
PRINT @@ROWCOUNT;
PRINT @@VERSION;
PRINT @@SPID;
PRINT @@ERROR;
PRINT @@SERVERNAME;
PRINT @@TRANCOUNT;
PRINT @@FETCH_STATUS;
PRINT @@NESTLEVEL;

-- 4
DECLARE @Z REAL, @T REAL, @X INT;
SET @T = 4;
SET @X = 4;

IF @T > @X
	BEGIN
		SET @Z = SIN(@T)*SIN(@T);
	END
ELSE IF @T < @X
	BEGIN
		SET @Z = 4*(@T + @X);
	END
ELSE 
	BEGIN
		SET @Z = 1-EXP(@X-2);
	END

PRINT @Z
GO
 
USE K_UNIVER;
GO

SELECT NAME FROM STUDENT
GO
DECLARE @SECOND_NAME NVARCHAR(20) = (SELECT LEFT(NAME,PATINDEX('% %',NAME)-1) FROM STUDENT)
 drop table #STR


SELECT 
	LEFT( NAME, PATINDEX( '% %', NAME ) - 1 ) AS FSTR_,
	SUBSTRING(NAME, PATINDEX('% %', NAME) + 1, LEN(NAME) - PATINDEX('%_ _%', NAME) ) AS STR_
	INTO #STR
	FROM STUDENT

SELECT * FROM #STR

SELECT 
	FSTR_ + ' ' +
	LEFT( LEFT( STR_, PATINDEX( '%_ _%', STR_ ) ), 1 ) + '. ' +
	LEFT(	SUBSTRING( STR_, PATINDEX( '% %', STR_ ) + 1, LEN( STR_ ) - 
				PATINDEX( '%_ _%', STR_ ) ), 1 ) + '.'
	FROM #STR

GO


DECLARE @CUR_MON INT = MONTH( GETDATE() ),
				@CUR_YEAR INT = YEAR( GETDATE() );

SELECT 
	NAME, BDAY, 
	( @CUR_YEAR - YEAR( BDAY ) ) AS AGE
	FROM STUDENT
	WHERE 
		@CUR_MON + 1 = MONTH( BDAY ) 
GO

DECLARE @GROUP INT = 4;

SELECT 
	GROUPS.IDGROUP,
	STUDENT.NAME,
	PROGRESS.SUBJECT,
	PROGRESS.NOTE,
	DAY( PROGRESS.PDATE ) AS DAY
	FROM
		GROUPS
			JOIN STUDENT
				ON GROUPS.IDGROUP = STUDENT.IDGROUP
			JOIN PROGRESS
				ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	WHERE GROUPS.IDGROUP = @GROUP AND
				PROGRESS.SUBJECT = 'СУБД'
	
SELECT * FROM GROUPS

USE K_UNIVER
-- 5

DECLARE @COUNT INT =
	( SELECT SUM( AUDITORIUM_CAPACITY ) FROM AUDITORIUM );
	
IF ( @COUNT > 400 )
	BEGIN
		PRINT 'Вместимость аудиторий больше 400';
		PRINT 'Вместимость: ' + CAST( @COUNT AS VARCHAR( 10 ) );
	END
ELSE
		BEGIN
			PRINT 'Вместимость аудиторий меньше 400';
			PRINT 'Вместимость: ' + CAST( @COUNT AS VARCHAR( 10 ) );
		END

-- 6

SELECT 
	CASE 
		WHEN PROGRESS.NOTE BETWEEN 0 AND 3 THEN 'НЕ УД'
		WHEN PROGRESS.NOTE BETWEEN 4 AND 6 THEN 'УД'
		WHEN PROGRESS.NOTE BETWEEN 7 AND 9 THEN 'ХОРОШО'
		ELSE 'ОТЛИЧНО'
	END
	FROM PROGRESS
	GROUP BY 
		CASE 
			WHEN PROGRESS.NOTE BETWEEN 0 AND 3 THEN 'НЕ УД'
			WHEN PROGRESS.NOTE BETWEEN 4 AND 6 THEN 'УД'
			WHEN PROGRESS.NOTE BETWEEN 7 AND 9 THEN 'ХОРОШО'
			ELSE 'ОТЛИЧНО'
		END

-- 7

drop table #Accounts

CREATE TABLE #Accounts ( CreatedAt DATE, Balance MONEY, Delta MONEY );
 
DECLARE @rate FLOAT, @period INT, @sum MONEY, @date DATE, @delta MONEY, @temp MONEY;
SET @date = GETDATE();
SET @rate = 0.065;
SET @period = 10;
SET @sum = 10000;
SET @temp = @sum; 

WHILE @period > 0
    BEGIN
        INSERT INTO #Accounts VALUES( @date, @sum, @delta );
        SET @period = @period - 1;
        SET @date = DATEADD(year, 1, @date);
        SET @sum = @sum + @sum * @rate;
				SET @delta = @sum - @temp;
				SET @temp = @sum;
    END;
 
SELECT * FROM #Accounts;

-- 8

DECLARE @X INT = 1;
	WHILE @X > 0
		BEGIN
			SET @X = @X + 1;
			PRINT @X;
			IF @X = 5
				RETURN;
		END

-- 9

DROP TABLE #Account

CREATE TABLE #Account (FirstName NVARCHAR NOT NULL, Age INT NOT NULL)
 
BEGIN TRY
    INSERT INTO #Account VALUES(NULL, NULL)
    PRINT 'Данные успешно добавлены!'
END TRY
BEGIN CATCH
    PRINT 'Error     ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ':' + ERROR_MESSAGE();
		PRINT 'ERROR_LINE    ' + CONVERT( VARCHAR, ERROR_LINE() );
		PRINT 'ERROR_PROCEDURE    ' + CONVERT( VARCHAR, ERROR_PROCEDURE());
		PRINT 'ERROR_SEVERITY ' + CONVERT( VARCHAR, ERROR_SEVERITY());
		PRINT 'ERROR_STATE    ' + CONVERT( VARCHAR, ERROR_STATE());
END CATCH

--цикл 10 дней начиная с сегодняшнего дня через 2 дня 

DECLARE @dt datetime = getdate();
DECLARE @d INT = 0;
	WHILE @d < 10
		BEGIN
			SET @d = @d +2;
			print @dt + @d;
		END






