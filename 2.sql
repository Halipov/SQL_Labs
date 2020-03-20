--�1 ������� ���� ������


CREATE DATABASE Univer;
GO


--�2 ������� ������� � ����� ���������
USE Univer;

CREATE TABLE Student(
	�����_������� int NOT NULL IDENTITY,
	������� nvarchar(15) NOT NULL,
	�����_������ int NOT NULL,
	CONSTRAINT PK_Student_Number PRIMARY KEY (�����_�������)
);
Go


--�3 �������� ������� � ������� �������

--ALTER TABLE Student ADD ����_����������� date;
--ALTER TABLE Student DROP COLUMN ����_�����������;



--�4 ������ ������
INSERT INTO Student (�������, �����_������) 
	VALUES  ('���1', 7), 
			('���2', 10),
			('���3', 10), 
			('���4', 3),
			('���5', 7), 
			('���6', 1),
			('���7', 8);
		
		
			
--�5 �������� ��� select

--SELECT * FROM Student;
--SELECT ������� FROM Student;
--SELECT �����_�������, ������� FROM Student;
--SELECT COUNT(*) AS ����������_�����_�_������� FROM Student;



--�6 �������� �������� ������ �� 5, ������� ������, � ������� ����� ������� ����� 5, �������, ������� �������

--UPDATE Student 
--	Set �����_������ = 5;
--DELETE FROM Student WHERE �����_������� = 5;
--SELECT * FROM Student;
--DROP TABLE Student;




--�7  ������� �������

--CREATE TABLE Student(
--	�����_������� int NOT NULL IDENTITY,
--	������� nvarchar(15) NOT NULL,
--	�����_������ int NOT NULL,
--	CONSTRAINT PK_Student_Number PRIMARY KEY (�����_�������)
--);
--Go

--INSERT INTO Student (�������, �����_������) 
--	VALUES  ('���1', 7), 
			--('���2', 10),
			--('���3', 10), 
			--('���4', 3),
			--('���5', 7), 
			--('���6', 1),
			--('���7', 8);
--UPDATE Student set �����_������� = 5;
--DROP TABLE Student;
--Go


--CREATE TABLE Student(
--	�����_������� int NOT NULL IDENTITY,
--	������� nvarchar(15) NOT NULL,
--	�����_������ int NOT NULL,
--	CONSTRAINT PK_Student_Number PRIMARY KEY (�����_�������)
--);
--Go


--ALTER TABLE Student ADD pol nchar(1) NOT NULL DEFAULT 'm' CHECK(pol in ('m', 'w')); 
--GO
--ALTER table student add pol nchar(10)


--INSERT INTO Student (�������, �����_������) 
--	VALUES  ('���1', 7), 
			--('���2', 10),
			--('���3', 10), 
			--('���4', 3),
			--('���5', 7), 
			--('���6', 1),
			--('���7', 8);			 

--SELECT * FROM Student;


--DROP TABLE Student;



--�8 ������� ������� result


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
--	values ('����',5,4),
--				 ('�������', 8, 3),
--				 ('����',default,default), 
--				 ('���������', 10, 10),
--				 ('�������',default,default);

--select * from results;
