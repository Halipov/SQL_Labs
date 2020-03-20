--USE K_UNIVER;

-- TASK 1
SET NOCOUNT ON;

IF EXISTS( SELECT * FROM SYS.objects
					 WHERE OBJECT_ID = object_id(N'DBO.T_1'))
	DROP TABLE T_1;

DECLARE @C INT = 0, @F CHAR = 'D';

SET IMPLICIT_TRANSACTIONS ON;

CREATE TABLE T_1 ( I INT );
INSERT T_1 VALUES (1), (2), (3);

SET @C = ( SELECT COUNT( * ) FROM T_1 );
PRINT @C;

IF @F = 'C' 
	COMMIT;
ELSE 
	ROLLBACK;

SET IMPLICIT_TRANSACTIONS OFF;

IF EXISTS( SELECT * FROM SYS.objects
					 WHERE OBJECT_ID = object_id(N'DBO.T_1'))
	PRINT 'SUCCES';
ELSE 
	PRINT 'FAIL';

	SELECT * FROM AUDITORIUM

--  TASK 2
BEGIN TRY
	BEGIN TRAN
		DELETE AUDITORIUM WHERE AUDITORIUM.AUDITORIUM = '206-1';
		INSERT AUDITORIUM VALUES ('TEST', 'KK', 555, 'TEST');
	COMMIT TRAN; 
END TRY
BEGIN CATCH
	PRINT 'ERROR: ' + CASE
	WHEN ERROR_NUMBER() = 2627 AND PATINDEX('%AUDITORIUM_PK%', ERROR_MESSAGE()) > 0
		THEN 'DUPLICATE'
		ELSE 'UNKHOW ERROR ' + CAST(ERROR_NUMBER() AS VARCHAR(5)) + ERROR_MESSAGE()
	END;
	IF @@TRANCOUNT > 0 
		ROLLBACK TRAN;
END CATCH

--  TASK 3

DECLARE @SAVE_POINT VARCHAR(30);
BEGIN TRY
	BEGIN TRAN
		DELETE AUDITORIUM WHERE AUDITORIUM.AUDITORIUM = '206-1';
		SET @SAVE_POINT = 'DELETE_SAVEPOINT';
		SAVE TRAN @SAVE_POINT;

		INSERT AUDITORIUM VALUES ('TEST', 'KK', 555, 'TEST');
		SET @SAVE_POINT = 'INSERT_SAVEPOINT';
		SAVE TRAN @SAVE_POINT;

	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'ERROR: ' + CASE
	WHEN ERROR_NUMBER() = 2627 AND PATINDEX('%AUDITORIUM_PK%', ERROR_MESSAGE()) > 0
		THEN 'DUPLICATE'
		ELSE 'UNKHOW ERROR ' + CAST(ERROR_NUMBER() AS VARCHAR(5)) + ERROR_MESSAGE()
	END;
	IF @@TRANCOUNT > 0 
	BEGIN
		PRINT 'SAVEPOINT ' + @SAVE_POINT;
		ROLLBACK TRAN @SAVE_POINT;
		COMMIT TRAN;
	END
END CATCH

--  TASK 4

SELECT * FROM AUDITORIUM
SELECT * FROM AUDITORIUM_TYPE

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
	--
	SELECT @@SPID, 'INSERT', * FROM AUDITORIUM
		WHERE AUDITORIUM.AUDITORIUM_NAME = '236-1';
	SELECT @@SPID, 'UPDATE', * FROM AUDITORIUM_TYPE
		WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPENAME = '���������� �����������';
COMMIT
	--

BEGIN TRAN
	SELECT @@SPID;
	INSERT AUDITORIUM VALUES ('0', '��-X', 25, '1' );
	UPDATE AUDITORIUM_TYPE SET AUDITORIUM_TYPE.AUDITORIUM_TYPENAME = '��-XXX'
		WHERE AUDITORIUM_TYPE.AUDITORIUM_TYPENAME = '��-X';
	--
	--
ROLLBACK;

--  TASK 5

SELECT * FROM AUDITORIUM
SELECT * FROM AUDITORIUM_TYPE

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
	SELECT COUNT( * ) FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_CAPACITY = 15;
	--
	--
	SELECT 'UPDATE', COUNT( * ) FROM AUDITORIUM
		WHERE AUDITORIUM.AUDITORIUM_CAPACITY = 15;
COMMIT


BEGIN TRAN
	--
	UPDATE AUDITORIUM SET AUDITORIUM_CAPACITY = 15
		WHERE AUDITORIUM_CAPACITY = 50;
COMMIT;
	--


--  TASK 6 
SELECT * FROM AUDITORIUM

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
	SELECT AUDITORIUM.AUDITORIUM_NAME FROM AUDITORIUM
		WHERE AUDITORIUM.AUDITORIUM_CAPACITY = 15;
	--
	--
	SELECT CASE 
		WHEN AUDITORIUM.AUDITORIUM_NAME = '236-1'
			THEN 'INSERT'
			ELSE ''
			END 'RESULT', AUDITORIUM.AUDITORIUM_NAME FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_CAPACITY = 15;
COMMIT


BEGIN TRAN
	--
	INSERT AUDITORIUM VALUES ( '545', '��', 15, '236-1');
COMMIT;
	--

--  TASK 7

SELECT * FROM TASK_6

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN
	DELETE TASK_6 WHERE TASK_6.F2 % 5 + 1 = 0;
	INSERT TASK_6 VALUES (105077, 'FSDADFFGDSFF');
	UPDATE TASK_6 SET F3 = 'QQQQ' WHERE TASK_6.F2 % 4  = 0;
	SELECT * FROM TASK_6 WHERE TASK_6.F2 % 4  = 0;
	--
	SELECT * FROM TASK_6 WHERE TASK_6.F2 % 4  = 0;
	--
COMMIT;


BEGIN TRAN
	DELETE TASK_6 WHERE TASK_6.F2 % 5 + 1 = 0;
	INSERT TASK_6 VALUES (105077, 'FSDADFFGDSFF');
	UPDATE TASK_6 SET F3 = 'QQQQ' WHERE TASK_6.F2 % 4  = 0;
	SELECT * FROM TASK_6 WHERE TASK_6.F2 % 4  = 0;
	--
COMMIT
	SELECT * FROM TASK_6 WHERE TASK_6.F2 % 4  = 0;
  --


--  TASK 8
SELECT * FROM AUDITORIUM

BEGIN TRAN 
	INSERT AUDITORIUM_TYPE VALUES ( 'SSS', 'SSSSS' );
	BEGIN TRAN
		UPDATE AUDITORIUM SET AUDITORIUM_NAME = 'SSS' WHERE AUDITORIUM_TYPE = 'SSS';
	COMMIT;

	IF @@TRANCOUNT > 0
		ROLLBACK;

SELECT 
	(SELECT COUNT( * ) FROM AUDITORIUM WHERE AUDITORIUM_NAME = 'SSS' ),
	(SELECT COUNT( * ) FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPENAME = 'SSSSS' );


-- DOP
USE K_UNIVER


IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'Table1'))
	DROP TABLE Table1
CREATE TABLE Table1  (Id INT IDENTITY, Value INT)
INSERT INTO Table1 (Value) VALUES(1)


-- DIRTY READ

BEGIN TRAN;

UPDATE Table1
SET Value = Value * 10
WHERE Id = 1;

WAITFOR DELAY '00:00:10';

ROLLBACK;

SELECT Value 
FROM Table1
WHERE Id = 1;

--non-repeatable read

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN;

SELECT Value 
FROM Table1
WHERE Id = 1;

WAITFOR DELAY '00:00:10';

SELECT Value 
FROM Table1
WHERE Id = 1;

COMMIT;


--phantom reads

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  
BEGIN TRAN;

SELECT * FROM Table1  

WAITFOR DELAY '00:00:10'  

SELECT * FROM Table1

COMMIT;