USE K_UNIVER;
 
 -- DIRTY READ
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRAN;

SELECT Value 
FROM Table1
WHERE Id = 1;

COMMIT TRAN;


--non-repeatable read

BEGIN TRAN;

UPDATE Table1 
SET Value = 42
WHERE Id = 1;

COMMIT TRAN;

--phantom reads


BEGIN TRAN;

INSERT INTO Table1 (Value)
VALUES(100)

COMMIT TRAN;