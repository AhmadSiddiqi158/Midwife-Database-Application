-- Include your INSERT SQL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the INSERT statements for the tables with foreign key references
--    ONLY AFTER the parent tables!

-- This is only an example of how you add INSERT statements to this file.
--   You may remove it.
--INSERT INTO MYTEST01 (id, value) VALUES(4, 1300);
-- A more complex syntax that saves you typing effort.
--INSERT INTO MYTEST01 (id, value) VALUES
-- (7, 5144)
--,(3, 73423)
--,(6, -1222)
--;

-- MOTHER
INSERT INTO MOTHER (hcardID,email,name,dateOfbirth,bloodtype,phonenum,currprofession,address) values
('ABCD-000-0001','mom1@gmail.com','Victoria Gutierrez','2000-06-13','B+','514-123-4433','student','street1'),
('ABCD-000-0002','mom2@gmail.com','mom2','2000-06-13','B+','514-123-4433','student','street1'),
('ABCD-000-0003','mom3@gmail.com','mom3','2000-06-13','A+','514-123-4433','Accountant','street1'),
('ABCD-000-0004','mom4@gmail.com','mom4','2000-06-13','A+','514-123-4433','Accountant','street1'),
('ABCD-000-0005','mom5@gmail.com','mom5','2000-06-13','A+','514-123-4433','Engineer','street1')
;

-- FATHER
INSERT INTO FATHER (fatherID,email,name,dateOfbirth,bloodtype,hcardID,phonenum,currprofession,address) values
(101,'dad1@gmail.com','dad1','2000-06-14','A+','ABCD-000-1111','514-123-4433','father','street1'),
(102,'dad2@gmail.com','dad2','2000-06-14','A+','ABCD-000-1112','514-123-4433','father','street1'),
(103,'dad3@gmail.com','dad3','2000-06-14','B+','ABCD-000-1113','514-123-4433','Banker','street2'),
(104,'dad4@gmail.com','dad4','2000-06-14','B+','ABCD-000-1114','514-123-4433','Data Scientist','street2'),
(105,'dad5@gmail.com','dad5','2000-06-14','B+','ABCD-000-1115','514-123-4433','Software Engineer','street2')
;

-- COUPLE
INSERT INTO COUPLE (coupleID,pregnancyNum,fatherID,hcardID) values
(111,2,101,'ABCD-000-0001'),
(112,1,102,'ABCD-000-0002'),
(113,2,103,'ABCD-000-0003'),
(114,0,104,'ABCD-000-0004'),
(115,0,105,'ABCD-000-0005')
;

-- HEALTHCARE_INSTITUTION
INSERT INTO HEALTHCARE_INSTITUTION (institution_email,name,phonenum,address,website) values
('hop1@gmail.com','hop1','514-123-4433','street1','www.hop1.com'),
('hop2@gmail.com','hop2','514-123-4433','street2','www.hop2.com'),
('hop3@gmail.com','hop3','514-123-4433','street3','www.hop3.com'),
('hop4@gmail.com','hop4','514-123-4433','street4','www.hop4.com'),
('lac-Saint.l@gmail.com','Lac-Saint-Louis','514-123-4433','street5','www.lacLouis.com')
;

-- MIDWIFE
INSERT INTO MIDWIFE (pID,midwife_name,midwife_email,midwife_phonenum,institution_email) values
(221,'Marion Girard','marion.g@gmail.com','514-123-4433','hop1@gmail.com'),
(222,'midwife2','midwife2@gmail.com','514-123-4433','hop2@gmail.com'),
(223,'midwife3','midwife3@gmail.com','514-123-4433','hop3@gmail.com'),
(224,'midwife4','midwife4@gmail.com','514-123-4433','lac-Saint.l@gmail.com'),
(225,'midwife5','midwife5@gmail.com','514-677-3213','lac-Saint.l@gmail.com')
;

-- ONLINE_INFO_SESSION
INSERT INTO ONLINE_INFO_SESSION (sessionID,time,session_language,session_date,pID) values
(331,'15:30:00','English','2022-01-01',221),
(332,'15:30:00','English','2022-01-02',222),
(333,'15:30:00','English','2022-01-03',223),
(334,'15:30:00','English','2022-01-04',224),
(335,'15:30:00','English','2022-01-05',225)
;

-- SESSION_ATTENDANCE
INSERT INTO SESSION_ATTENDANCE (sessionID,coupleID) values
(331,111),
(331,112),
(331,113),
(334,114),
(335,115)
;

-- PREGNANCY
INSERT INTO PREGNANCY (pregID,num_of_babies,birthLocation,birthTimeFrameym,finalDate,isPreg) values
(441,1,'street4','2022-07', NULL,true),
(442,2,'street4','2022-08', '2022-07-15',true),
(443,1,'street4','2022-09', NULL,true),
(444,1,'street4','2022-10', '2022-07-01',true),
(445,3,'street4','2022-07', '2022-07-17',true)
;

-- PREGNANCY_MIDWIFE_ASSISTANCE
INSERT INTO PREGNANCY_MIDWIFE_ASSISTANCE (pregID,pID,isPrimaryMidwife) values
(441,221,true),
(442,221,true),
(443,221,true),
(444,224,true),
(445,225,false)
;

-- APPOINTMENT
INSERT INTO APPOINTMENT (appointmentID,a_date,a_time,pID,pregID) values
(551,'2022-03-20','09:00:00',221,441),
(552,'2022-03-21','10:00:00',221,442),
(553,'2022-03-25','09:30:00',221,443),
(554,'2022-04-10','11:00:00',224,444),
(555,'2022-04-10','16:00:00',225,445)
;

-- NOTES
INSERT INTO NOTES (noteID,note_date,note_time,appointmentID) values
(601,'2022-03-20','09:05:00',551),
(602,'2022-03-21','10:05:00',552),
(603,'2022-03-25','09:35:00',553),
(604,'2022-04-10','11:05:00',554),
(605,'2022-04-10','16:05:00',555)
;

-- CHILD
INSERT INTO CHILD (childID,name,dateOfbirth,dateofbirth_time,gender,bloodType,pregID) values
(701,'baby1','2022-11-10','04:05:00','M','B-',441),
(702,'baby2','2022-11-10','05:05:00','F','A-',442),
(703,'baby3','2022-11-10','06:05:00','M','O', 443),
(704,'baby4','2022-11-10','07:05:00','F','B+',444),
(705,'baby5','2022-11-10','08:05:00','M','A+',445)
;

-- EXPECTED_DATE
INSERT INTO EXPECTED_DATE(expected_dateID,EXPECTED_DATE) values
(11,'2022-09-11'),
(12,'2022-08-11'),
(13,'2022-07-11'),
(14,'2022-06-11'),
(15,'2022-05-11')
;

-- DUE_DATES
INSERT INTO DUE_DATES (expected_dateID,pregID) values
(11,441),
(12,442),
(13,443),
(14,444),
(15,445)
;

-- COUPLE_PREGNANCY
INSERT INTO COUPLE_PREGNANCY(coupleID,pregID) values
(111,441),
(112,442),
(113,443),
(114,444),
(115,445)
;

-- MEDICAL_TEST
INSERT INTO MEDICAL_TEST(testID,prescribed_date,sample_taken_date,performed_labwork_date,test_sample,test_type,test_result,technicianID,technicianName,technicianPhonenum,pregID) values
(801,'2022-02-10','2022-02-12','2022-02-17','blood','Blood iron','low',901,'Mary','123-432-4433',441),
(802,'2022-02-10','2022-02-12','2022-02-17','blood','sugar','high',902,'Charlie','123-432-4433',442),
(803,'2022-02-10','2022-02-12','2022-02-17','blood','sugar','border line',903,'Megan','123-432-4433',443),
(804,'2022-02-10','2022-02-12','2022-02-17','blood','thyroid','high',904,'Trump','123-432-4433',444),
(805,'2022-02-10','2022-02-12','2022-02-17','blood','thyroid','low',905,'Biden','123-432-4433',445),
(806,'2022-02-20','2022-02-22','2022-02-23','blood','Blood iron','high',906,'Bob','123-432-4433',441),
(807,'2022-03-10','2022-03-12','2022-03-17','blood','Blood iron','normal',907,'Kim','123-432-4433',441)
;
