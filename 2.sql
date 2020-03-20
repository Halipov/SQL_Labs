--№1 Создать базу данных


CREATE DATABASE Univer;
GO


--№2 создать таблицу с тремя столбцами
USE Univer;

CREATE TABLE Student(
	номер_зачетки int NOT NULL IDENTITY,
	фамилия nvarchar(15) NOT NULL,
	номер_группы int NOT NULL,
	CONSTRAINT PK_Student_Number PRIMARY KEY (номер_зачетки)
);
Go


--№3 добавить столбец и удалить столбец

--ALTER TABLE Student ADD дата_поступления date;
--ALTER TABLE Student DROP COLUMN дата_поступления;



--№4 ввести данные
INSERT INTO Student (фамилия, номер_группы) 
	VALUES  ('фам1', 7), 
			('фам2', 10),
			('фам3', 10), 
			('фам4', 3),
			('фам5', 7), 
			('фам6', 1),
			('фам7', 8);
		
		
			
--№5 написать три select

--SELECT * FROM Student;
--SELECT фамилия FROM Student;
--SELECT номер_зачетки, фамилия FROM Student;
--SELECT COUNT(*) AS Количество_строк_в_таблице FROM Student;



--№6 изменить значение группы на 5, удалить строку, у которой номер зачетки равен 5, вывести, удалить таблицу

--UPDATE Student 
--	Set номер_группы = 5;
--DELETE FROM Student WHERE номер_зачетки = 5;
--SELECT * FROM Student;
--DROP TABLE Student;




--№7  создать таблицу

--CREATE TABLE Student(
--	номер_зачетки int NOT NULL IDENTITY,
--	фамилия nvarchar(15) NOT NULL,
--	номер_группы int NOT NULL,
--	CONSTRAINT PK_Student_Number PRIMARY KEY (номер_зачетки)
--);
--Go

--INSERT INTO Student (фамилия, номер_группы) 
--	VALUES  ('фам1', 7), 
			--('фам2', 10),
			--('фам3', 10), 
			--('фам4', 3),
			--('фам5', 7), 
			--('фам6', 1),
			--('фам7', 8);
--UPDATE Student set номер_зачетки = 5;
--DROP TABLE Student;
--Go


--CREATE TABLE Student(
--	номер_зачетки int NOT NULL IDENTITY,
--	фамилия nvarchar(15) NOT NULL,
--	номер_группы int NOT NULL,
--	CONSTRAINT PK_Student_Number PRIMARY KEY (номер_зачетки)
--);
--Go


--ALTER TABLE Student ADD pol nchar(1) NOT NULL DEFAULT 'm' CHECK(pol in ('m', 'w')); 
--GO
--ALTER table student add pol nchar(10)


--INSERT INTO Student (фамилия, номер_группы) 
--	VALUES  ('фам1', 7), 
			--('фам2', 10),
			--('фам3', 10), 
			--('фам4', 3),
			--('фам5', 7), 
			--('фам6', 1),
			--('фам7', 8);			 

--SELECT * FROM Student;


--DROP TABLE Student;



--№8 создать таблицу result


--create table results(
--	id int identity,
--	student_name nvarchar(25) not null,
--	mark_first_subject int default 4,
--	mark_second_subject int default 4,
--	aver_value as (mark_first_subject + mark_second_subject)/2,
--	constraint pk_results_id primary key (id),
--	constraint ck_correct_first_mark check(mark_first_subject >= 0 and mark_first_subject <= 10),
--	constraint ck_correct_second_mark check(mark_second_subject >= 0 and mark_second_subject <= 10)
--);
--go

--insert into results (student_name, mark_first_subject, mark_second_subject)
--	values ('олег',5,4),
--				 ('виталий', 8, 3),
--				 ('петр',default,default), 
--				 ('владислав', 10, 10),
--				 ('дмитрий',default,default);

--select * from results;
