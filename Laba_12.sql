USE K_UNIVER;
GO 


-- 1

DECLARE @TEMP_STR CHAR(20), @STR CHAR(300)='';
DECLARE CURSOR_T1 CURSOR 
	FOR SELECT SUBJECT.SUBJECT FROM SUBJECT		
				WHERE SUBJECT.PULPIT = '�+6���';

OPEN CURSOR_T1;
FETCH CURSOR_T1 INTO @TEMP_STR;
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @STR = RTRIM(@TEMP_STR) + ', ' + @STR;
		FETCH CURSOR_T1 INTO @TEMP_STR;
	END;
CLOSE CURSOR_T1;
DEALLOCATE CURSOR_T1 

SELECT @STR; 
GO

-- 2
DECLARE CURSOR_T2_L CURSOR LOCAL
	FOR SELECT SUBJECT.PULPIT, SUBJECT.SUBJECT_NAME FROM SUBJECT;
DECLARE @STR_T CHAR(20), @STR CHAR(100);
OPEN CURSOR_T2_L;
FETCH CURSOR_T2_L INTO @STR_T, @STR;
PRINT '1. ' + @STR_T + ' ' + @STR;
GO
DECLARE @STR_T CHAR(20), @STR CHAR(100);
FETCH CURSOR_T2_L INTO @STR_T, @STR;
PRINT '2. ' + @STR_T + ' ' + @STR;
GO
CLOSE CURSOR_T2_L;
DEALLOCATE CURSOR_T2_L;


DECLARE CURSOR_T2_G CURSOR GLOBAL
	FOR SELECT SUBJECT.PULPIT, SUBJECT.SUBJECT_NAME FROM SUBJECT;
DECLARE @STR_T CHAR(20), @STR CHAR(100);
OPEN CURSOR_T2_G;
FETCH CURSOR_T2_G INTO @STR_T, @STR;
PRINT '1. ' + @STR_T + ' ' + @STR;
GO
DECLARE @STR_T CHAR(20), @STR CHAR(100);
FETCH CURSOR_T2_G INTO @STR_T, @STR;
PRINT '2. ' + @STR_T + ' ' + @STR;
GO

CLOSE CURSOR_T2_G;
DEALLOCATE CURSOR_T2_G;

SELECT * FROM SUBJECT

--  TASK 3
DECLARE @SUBJECT CHAR(10), @SUBJECT_NAME CHAR(100), @PULPIT CHAR(20);
DECLARE CURSOR_T3_LS CURSOR LOCAL STATIC
	FOR SELECT SUBJECT.SUBJECT, SUBJECT.SUBJECT_NAME, SUBJECT.PULPIT
				FROM SUBJECT;

OPEN CURSOR_T3_LS;
PRINT @@CURSOR_ROWS;
UPDATE SUBJECT SET SUBJECT.SUBJECT_NAME = 'IT'
	WHERE SUBJECT.SUBJECT_NAME = '�������������� ����������';
DELETE SUBJECT WHERE SUBJECT.SUBJECT = 'T1';
INSERT SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
	VALUES ('T1','TEST NAME', '����');
FETCH CURSOR_T3_LS INTO @SUBJECT, @SUBJECT_NAME, @PULPIT;
WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @SUBJECT + RTRIM(@SUBJECT_NAME) + '    ' + @PULPIT;
		FETCH CURSOR_T3_LS INTO @SUBJECT, @SUBJECT_NAME, @PULPIT;
	END
CLOSE CURSOR_T3_LS;
GO


--  TASK 4
DECLARE @ROW_NUMB INT, @SUBJECT_NAME CHAR(50);;
DECLARE CURSOR_T4_LD CURSOR LOCAL DYNAMIC SCROLL
	FOR SELECT ROW_NUMBER() OVER
		(ORDER BY SUBJECT.SUBJECT_NAME),
		SUBJECT.SUBJECT_NAME FROM SUBJECT;
OPEN CURSOR_T4_LD;
	FETCH NEXT FROM CURSOR_T4_LD INTO @ROW_NUMB, @SUBJECT_NAME;
	PRINT 'NEXT FETCH  ' + CAST( @ROW_NUMB AS VARCHAR(3)) + ' ' + RTRIM(@SUBJECT_NAME);
	
	FETCH FIRST FROM CURSOR_T4_LD INTO @ROW_NUMB, @SUBJECT_NAME;
	PRINT 'FIRST FETCH  ' + CAST( @ROW_NUMB AS VARCHAR(3)) + ' ' + RTRIM(@SUBJECT_NAME);
	
	FETCH RELATIVE 3 FROM CURSOR_T4_LD INTO @ROW_NUMB, @SUBJECT_NAME;
	PRINT 'RELATIVE 3 FETCH  ' + CAST( @ROW_NUMB AS VARCHAR(3)) + ' ' + RTRIM(@SUBJECT_NAME);
	
		
	FETCH ABSOLUTE 3 FROM CURSOR_T4_LD INTO @ROW_NUMB, @SUBJECT_NAME;
	PRINT 'ABSOLUTE 3 FETCH  ' + CAST( @ROW_NUMB AS VARCHAR(3)) + ' ' + RTRIM(@SUBJECT_NAME);

	FETCH PRIOR FROM CURSOR_T4_LD INTO @ROW_NUMB, @SUBJECT_NAME;
	PRINT 'PRIOR FETCH  ' + CAST( @ROW_NUMB AS VARCHAR(3)) + ' ' + RTRIM(@SUBJECT_NAME);


	FETCH LAST FROM CURSOR_T4_LD INTO @ROW_NUMB, @SUBJECT_NAME;
	PRINT 'LAST FETCH  ' + CAST( @ROW_NUMB AS VARCHAR(3)) + ' ' + RTRIM(@SUBJECT_NAME);


	FETCH ABSOLUTE -3 FROM CURSOR_T4_LD INTO @ROW_NUMB, @SUBJECT_NAME;
	PRINT 'ABSOLUTE -3 FETCH  ' + CAST( @ROW_NUMB AS VARCHAR(3)) + ' ' + RTRIM(@SUBJECT_NAME);
	
	
	FETCH RELATIVE -3 FROM CURSOR_T4_LD INTO @ROW_NUMB, @SUBJECT_NAME;
	PRINT 'RELATIVE -3 FETCH  ' + CAST( @ROW_NUMB AS VARCHAR(3)) + ' ' + RTRIM(@SUBJECT_NAME);

CLOSE CURSOR_T4_LD;
GO


--  TASK 5
DECLARE @SUBJECT CHAR(15), @SUBJECT_NAME CHAR(50), @PULPIT CHAR(25);
DECLARE CURSOR_T5_LD CURSOR LOCAL DYNAMIC
	FOR SELECT SUBJECT.SUBJECT, SUBJECT.SUBJECT_NAME, SUBJECT.SUBJECT_NAME
			FROM SUBJECT FOR UPDATE;

OPEN CURSOR_T5_LD;
	FETCH CURSOR_T5_LD INTO @SUBJECT, @SUBJECT_NAME, @PULPIT;
	DELETE SUBJECT WHERE CURRENT OF CURSOR_T5_LD;
	FETCH CURSOR_T5_LD INTO @SUBJECT, @SUBJECT_NAME, @PULPIT;
	UPDATE SUBJECT SET SUBJECT_NAME = ' IT IT ' WHERE CURRENT OF CURSOR_T5_LD;
CLOSE CURSOR_T5_LD;


--  TASK 6
SELECT * FROM PROGRESS;
SELECT * FROM STUDENT;
SELECT * FROM GROUPS;

CREATE TABLE #T_PROGRESS(
	SUBJECT CHAR(10),
	IDSTUDENT INT,
	PDATE DATE,
	NOTE INT
);

INSERT INTO #T_PROGRESS
	SELECT * FROM PROGRESS


SELECT * FROM #T_PROGRESS


DECLARE @NAME CHAR(70), @IDGROUP INT, @NOTE INT;
DECLARE CURSOR_T6_LD CURSOR LOCAL DYNAMIC
	FOR SELECT STUDENT.NAME, GROUPS.IDGROUP, #T_PROGRESS.NOTE
				FROM GROUPS
					JOIN STUDENT
						ON STUDENT.IDGROUP = GROUPS.IDGROUP
					JOIN #T_PROGRESS
						ON #T_PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
				WHERE #T_PROGRESS.NOTE <= 4
	FOR UPDATE;

OPEN CURSOR_T6_LD;
	FETCH CURSOR_T6_LD INTO @NAME, @IDGROUP, @NOTE;
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			DELETE #T_PROGRESS WHERE CURRENT OF CURSOR_T6_LD;
			FETCH CURSOR_T6_LD INTO @NAME, @IDGROUP, @NOTE;	
		END
CLOSE CURSOR_T6_LD;
GO

SELECT * FROM PROGRESS WHERE PROGRESS.IDSTUDENT = 1000;

DECLARE @ID_STUD INT = 1000;

DECLARE @NAME CHAR(70), @IDGROUP INT, @NOTE INT;
DECLARE CURSOR_T6_LD CURSOR LOCAL DYNAMIC
	FOR SELECT STUDENT.NAME, GROUPS.IDGROUP, PROGRESS.NOTE
				FROM GROUPS
					JOIN STUDENT
						ON STUDENT.IDGROUP = GROUPS.IDGROUP
					JOIN PROGRESS
						ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
				WHERE STUDENT.IDSTUDENT = @ID_STUD
	FOR UPDATE;

OPEN CURSOR_T6_LD;
	FETCH CURSOR_T6_LD INTO @NAME, @IDGROUP, @NOTE;
	UPDATE PROGRESS SET NOTE = NOTE + 1 WHERE CURRENT OF CURSOR_T6_LD 
	
CLOSE CURSOR_T6_LD;


SELECT * FROM PROGRESS WHERE PROGRESS.IDSTUDENT = 1000;
