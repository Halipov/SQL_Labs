USE K_UNIVER


--1
SELECT TEACHER.TEACHER, TEACHER.TEACHER_NAME, RTRIM(TEACHER.PULPIT) AS PULPIT, TEACHER.GENDER
	FROM TEACHER WHERE TEACHER.PULPIT = 'ИСиТ'
	FOR XML RAW('TEACHER'), ROOT('TEACCHERS'), ELEMENTS;

--2
SELECT AUDITORIUM.AUDITORIUM_NAME, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
	AUDITORIUM.AUDITORIUM_CAPACITY
	FROM AUDITORIUM
		JOIN AUDITORIUM_TYPE
			ON AUDITORIUM_TYPE.AUDITORIUM_TYPE = AUDITORIUM.AUDITORIUM_TYPE AND
				AUDITORIUM_TYPE.AUDITORIUM_TYPE = 'ЛК'
	ORDER BY  AUDITORIUM.AUDITORIUM_NAME FOR XML AUTO,
	ROOT('AUDITORIUMS'), ELEMENTS

--3
SELECT * FROM SUBJECT

DECLARE @HANDLE INT = 0,
	@XML VARCHAR(2000) = 
	'<?xml version="1.0" encoding="windows-1251"?>
	 <subjects>
		<subject SUBJECT="SUB_1" SUBJECT_NAME="SUB_1_NAME" PULPIT="ИСиТ"/>
		<subject SUBJECT="SUB_2" SUBJECT_NAME="SUB_3_NAME" PULPIT="ИСиТ"/>
		<subject SUBJECT="SUB_3" SUBJECT_NAME="SUB_3_NAME" PULPIT="ИСиТ"/>
	 </subjects>'
	 EXEC SP_XML_PREPAREDOCUMENT @HANDLE OUTPUT, @XML;
	 SELECT * FROM OPENXML(@HANDLE, '/subjects/subject',0)
		WITH (SUBJECT CHAR(10), SUBJECT_NAME VARCHAR(100), PULPIT CHAR(20))
	 EXEC SP_XML_REMOVEDOCUMENT @HANDLE;
GO

DECLARE @HANDLE INT = 0,
	@XML VARCHAR(2000) = 
	'<?xml version="1.0" encoding="windows-1251"?>
	 <subjects>
		<subject SUBJECT="SUB_1" SUBJECT_NAME="SUB_1_NAME" PULPIT="ИСиТ"/>
		<subject SUBJECT="SUB_2" SUBJECT_NAME="SUB_2_NAME" PULPIT="ИСиТ"/>
		<subject SUBJECT="SUB_3" SUBJECT_NAME="SUB_3_NAME" PULPIT="ИСиТ"/>
	 </subjects>'
	 EXEC SP_XML_PREPAREDOCUMENT @HANDLE OUTPUT, @XML;
	 INSERT SUBJECT SELECT SUBJECT, SUBJECT_NAME, PULPIT
		FROM OPENXML(@HANDLE, '/subjects/subject')
		WITH (SUBJECT CHAR(10), SUBJECT_NAME VARCHAR(100), PULPIT CHAR(20))
	 EXEC SP_XML_REMOVEDOCUMENT @HANDLE;

	 SELECT * FROM SUBJECT
	 GO
--  TASK 4
DELETE STUDENT WHERE STUDENT.NAME = 'TEST TEST TEST'

DECLARE @XML VARCHAR(500) = 
	'<root>
	<PASSPORT>
		<SERIA>MP</SERIA>
		<NUMBER>54654</NUMBER>
		<SELFNUMBER>546486DSF464879</SELFNUMBER>
		<DATE>12.12.2012</DATE>
		<ADDRESS>МИНСК УЛ.БОБРУЙСКАЯ 25, К.421</ADDRESS>
	 </PASSPORT>
		</root>';
	INSERT STUDENT(NAME, IDGROUP, INFO)
		VALUES
			('TEST TEST TESTm',19,@XML);
			SELECT * FROM STUDENT

SELECT NAME, INFO.value('(/root/PASSPORT/SERIA)[1]', 'char(2)'),
	INFO.value('(/root/PASSPORT/NUMBER)[1]', 'char(6)'),
	INFO.query('/root/PASSPORT/ADDRESS') 
	FROM STUDENT WHERE STUDENT.NAME = 'TEST TEST TESTm';


--5
CREATE XML SCHEMA COLLECTION STUDENT AS 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
       <xs:element name="студент">  
       <xs:complexType><xs:sequence>
       <xs:element name="паспорт" maxOccurs="1" minOccurs="1">
       <xs:complexType>
       <xs:attribute name="серия" type="xs:string" use="required" />
       <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
       <xs:attribute name="дата"  use="required" >  
       <xs:simpleType>  <xs:restriction base ="xs:string">
   <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
   </xs:restriction> 	</xs:simpleType>
   </xs:attribute> </xs:complexType> 
   </xs:element>
   <xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
   <xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
   </xs:sequence></xs:complexType>  </xs:element>
   </xs:sequence></xs:complexType>
   </xs:element>
</xs:schema>';

ALTER TABLE STUDENT ALTER COLUMN INFO XML(STUDENT);

INSERT STUDENT (IDGROUP, NAME, BDAY, INFO)
	VALUES
		(19,'test test test','01.01.2000',
			'<студент>
				<паспорт серия="НB" номер="6799765" дата="25.10.2011"/>
				<телефон>2434353</телефон>
				<адрес>
					<страна>Беларусь</страна>
					<город>Добруш</город>
					<улица>Микр 1</улица>
					<дом>2Б</дом>
					<квартира>8</квартира>
				</адрес>
			</студент>');

DELETE FROM STUDENT WHERE  NAME = 'test test test';

UPDATE STUDENT
	SET INFO = 
	'<студент>
		<паспорт серия="НB" номер="6799765" дата="25.10.2011"/>
		<телефон>2434353</телефон>
		<адрес>
			<страна>Беларусь</страна>
			<город>Мозырь</город>
			<улица>Ленина</улица>
			<дом>57</дом>
			<квартира>7</квартира>
		</адрес>
	</студент>'
	WHERE INFO.value('(студент/адрес/город)[1]','varchar(10)') = 'Добруш';

SELECT STUDENT.IDGROUP, STUDENT.NAME, STUDENT.BDAY,
	STUDENT.INFO.value('(/студент/адрес/страна)[1]','varchar(10)'),
	STUDENT.INFO.query('/студент/адрес')
	FROM STUDENT;