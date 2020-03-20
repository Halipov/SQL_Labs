USE K_UNIVER;
GO

-- TASK 1
DROP VIEW Преподаватель;
GO
CREATE VIEW Преподаватель
	AS SELECT
			TEACHER AS Код,
		  TEACHER_NAME AS Имя_Преподавателя,
			GENDER AS Пол,
			PULPIT AS Код_кафедры 
		 FROM TEACHER
GO

SELECT * FROM Преподаватель 
	ORDER BY Код;


--  TASK 2
DROP VIEW Количество_кафедр;
GO
CREATE VIEW Количество_кафедр
	AS SELECT
		   FACULTY.FACULTY AS ФАКУЛЬТЕТ,
			 COUNT( PULPIT.PULPIT ) AS КОЛИЧЕСТВО_КАФЕДР
		 FROM FACULTY 
		   JOIN PULPIT
				ON FACULTY.FACULTY = PULPIT.FACULTY
		 GROUP BY  FACULTY.FACULTY;
GO

SELECT * FROM Количество_кафедр;

-- TASK 3
use K_UNIVER
DROP VIEW Аудитории
GO
CREATE VIEW Аудитории ( КОД, НАИМЕНОВАНИЕ_АУДИТОРИИ,  ТИП )
	AS SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE
		   FROM AUDITORIUM
			 WHERE AUDITORIUM_TYPE LIKE 'ЛК%';
GO

SELECT * FROM Аудитории;

INSERT Аудитории VALUES( 'TEST', 'TEST_NAME', 'ЛК' );
SELECT * FROM Аудитории;

UPDATE Аудитории
	 SET КОД = 'UPDATE' WHERE НАИМЕНОВАНИЕ_АУДИТОРИИ = 'TEST_NAME'
SELECT * FROM Аудитории;

DELETE FROM Аудитории WHERE НАИМЕНОВАНИЕ_АУДИТОРИИ = 'TEST_NAME'
SELECT * FROM Аудитории;

DELETE FROM AUDITORIUM WHERE AUDITORIUM_NAME = 'TEST_NAME'
SELECT * FROM AUDITORIUM;

-- TASK 4
DROP VIEW Аудитории_2;
GO
CREATE VIEW Аудитории_2 ( КОД, НАИМЕНОВАНИЕ_АУДИТОРИИ, ТИП )
	AS SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE
		   FROM AUDITORIUM
			 WHERE AUDITORIUM_TYPE LIKE 'ЛК%' WITH CHECK OPTION;
GO

SELECT * FROM Аудитории_2;

-- TASK 5
DROP VIEW ДИСЦИПЛИНЫ;
GO
CREATE VIEW ДИСЦИПЛИНЫ 
	( КОД, НАИМЕНОВАНИЕ_ДИСЦИПЛИНЫ, КОД_КАФЕДРЫ )
	AS SELECT TOP 50 SUBJECT, SUBJECT_NAME, PULPIT
		 FROM SUBJECT
		 ORDER BY SUBJECT_NAME;
GO

SELECT * FROM ДИСЦИПЛИНЫ;

-- TASK 6

ALTER VIEW Количество_кафедр WITH SCHEMABINDING
	AS SELECT
		   FACULTY.FACULTY AS ФАКУЛЬТЕТ,
			 COUNT( PULPIT.PULPIT ) AS КОЛИЧЕСТВО_КАФЕДР
		 FROM dbo.FACULTY 
		   JOIN dbo.PULPIT
				ON FACULTY.FACULTY = PULPIT.FACULTY
		 GROUP BY  FACULTY.FACULTY;
GO



--ДоПЫ
--создать представлние из трех таблиц 
use H_MyBase
Drop VIEW VIEW_3
CREATE VIEW VIEW_3 WITH SCHEMABINDING
	AS SELECT
		   Клиент.Фамилия, Клиент.Имя, Товары.Название_товара, Заказы.Количество
			 FROM 
			   dbo.Заказы
				   JOIN dbo.Товары
					   ON Заказы.ID_Товара = Товары.ID_Товара
					 JOIN dbo.Клиент
						 ON Заказы.ID_Клиента = Клиент.ID_Клиента;
GO
UPDATE Заказы
SET Количество = 33 where ID_Товара = 1;
	SELECT * FROM Заказы;
	SELECT * FROM VIEW_3;

	-- вставка данных


use K_UNIVER
DROP VIEW Аудитории
GO
CREATE VIEW Аудитории ( КОД, НАИМЕНОВАНИЕ_АУДИТОРИИ,  ТИП )
	AS SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE
		   FROM AUDITORIUM
			 WHERE AUDITORIUM_TYPE LIKE 'ЛК%';
GO

SELECT * FROM Аудитории;

INSERT Аудитории VALUES( 'TEST3', 'TEST_NAME', 'ЛК' );
SELECT * FROM Аудитории;
	