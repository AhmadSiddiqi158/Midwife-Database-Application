-- Include your create table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the create table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables has already been created.

-- This is only an example of how you add create table ddls to this file.
--   You may remove it.
/*CREATE TABLE MYTEST01
(
  id INTEGER NOT NULL
 ,value INTEGER
 ,PRIMARY KEY(id)
);*/

CREATE TABLE MOTHER
(
	hcardID VARCHAR(13) NOT NULL,
	email VARCHAR(35) NOT NULL,
	name VARCHAR(20) NOT NULL,
	dateOfbirth DATE NOT NULL,
	bloodtype VARCHAR(2),
	phonenum VARCHAR(15) NOT NULL,
	currprofession VARCHAR(30) NOT NULL,
	address VARCHAR(30) NOT NULL,
	PRIMARY KEY(hcardID)
);

CREATE TABLE FATHER
(
        fatherID INTEGER NOT NULL,
        email VARCHAR(35),
        name VARCHAR(20) NOT NULL,
        dateOfbirth DATE NOT NULL,
        bloodtype VARCHAR(2),
        hcardID VARCHAR(13),
        phonenum VARCHAR(15) NOT NULL,
        currprofession VARCHAR(30) NOT NULL,
        address VARCHAR(30),
        PRIMARY KEY(fatherID)
);

CREATE TABLE COUPLE
(
	coupleID INTEGER NOT NULL,
	pregnancyNum INTEGER NOT NULL,
	fatherID INTEGER,
	hcardID VARCHAR(13) NOT NULL,
	PRIMARY KEY(coupleID),
	FOREIGN KEY(fatherID) REFERENCES FATHER ON DELETE CASCADE,
	FOREIGN KEY(hcardID) REFERENCES MOTHER ON DELETE CASCADE
);

CREATE TABLE HEALTHCARE_INSTITUTION
(
	institution_email VARCHAR(35) NOT NULL,
	name VARCHAR(20) NOT NULL,
	phonenum VARCHAR(15) NOT NULL,
	address VARCHAR(30) NOT NULL,
	website VARCHAR(20) NOT NULL,
	PRIMARY KEY(institution_email)
);

CREATE TABLE MIDWIFE
(
	pID INTEGER NOT NULL,
	midwife_name VARCHAR(20) NOT NULL,
	midwife_email VARCHAR(35) NOT NULL,
	midwife_phonenum VARCHAR(15) NOT NULL,
	institution_email VARCHAR(35) NOT NULL,
	PRIMARY KEY(pID),
	FOREIGN KEY(institution_email) REFERENCES HEALTHCARE_INSTITUTION ON DELETE CASCADE
);

CREATE TABLE ONLINE_INFO_SESSION
(
	sessionID INTEGER NOT NULL,
	time TIME NOT NULL,
	session_language VARCHAR(10) NOT NULL,
	session_date DATE NOT NULL,
	pID INTEGER NOT NULL,
	PRIMARY KEY(sessionID),
        FOREIGN KEY(pID) REFERENCES MIDWIFE ON DELETE CASCADE
);

CREATE TABLE SESSION_ATTENDANCE
(
	sessionID INTEGER NOT NULL,
	coupleID INTEGER NOT NULL,
	PRIMARY KEY (sessionID,coupleID), 
	FOREIGN KEY(sessionID) REFERENCES ONLINE_INFO_SESSION ON DELETE CASCADE,
	FOREIGN KEY(coupleID) REFERENCES COUPLE ON DELETE CASCADE
);

CREATE TABLE PREGNANCY
(
	pregID INTEGER NOT NULL,
	num_of_babies INTEGER NOT NULL,
	birthLocation VARCHAR (30),
	birthtimeframeym VARCHAR(10) NOT NULL, --> year-month
	finalDate DATE,
	isPreg boolean NOT NULL,
	PRIMARY KEY(pregID)
);

CREATE TABLE PREGNANCY_MIDWIFE_ASSISTANCE
(
	pregID INTEGER NOT NULL,
	pID INTEGER NOT NULL,
	isPrimaryMidwife BOOLEAN NOT NULL,
	PRIMARY KEY (pregID,pID),
	FOREIGN KEY(pID) REFERENCES MIDWIFE ON DELETE CASCADE,
	FOREIGN KEY(pregID) REFERENCES PREGNANCY ON DELETE CASCADE
);

CREATE TABLE APPOINTMENT
(
	appointmentID INTEGER NOT NULL,
	a_date DATE NOT NULL,
	a_time TIME NOT NULL,
	pID INTEGER NOT NULL,
	pregID INTEGER NOT NULL,
	PRIMARY KEY (appointmentID),
	FOREIGN KEY(pID) REFERENCES MIDWIFE ON DELETE CASCADE,
        FOREIGN KEY(pregID) REFERENCES PREGNANCY ON DELETE CASCADE
);

CREATE TABLE NOTES
(
	noteID INTEGER NOT NULL,
	note_date DATE NOT NULL,
	note_time TIME NOT NULL,
	appointmentID INTEGER NOT NULL,
	PRIMARY KEY(noteID),
	FOREIGN KEY(appointmentID) REFERENCES APPOINTMENT ON DELETE CASCADE
);

CREATE TABLE CHILD
(
	childID INTEGER NOT NULL,
	name VARCHAR(20),
	dateOfbirth DATE,
	dateofbirth_time TIME,
	gender VARCHAR(1),
	bloodType VARCHAR(2),
	pregID INTEGER NOT NULL,
	PRIMARY KEY(childID),
	FOREIGN KEY(pregID) REFERENCES PREGNANCY ON DELETE CASCADE
);

CREATE TABLE EXPECTED_DATE
(
	expected_dateID INTEGER NOT NULL,
	expected_date DATE NOT NULL,
	PRIMARY KEY(expected_dateID)
);

CREATE TABLE DUE_DATES
(
	expected_dateID INTEGER NOT NULL,
	pregID INTEGER NOT NULL,
	PRIMARY KEY (expected_dateID, pregID),
	FOREIGN KEY(expected_dateID) REFERENCES EXPECTED_DATE ON DELETE CASCADE,
	FOREIGN KEY(pregID) REFERENCES PREGNANCY ON DELETE CASCADE
);

CREATE TABLE COUPLE_PREGNANCY
(
	coupleID INTEGER NOT NULL,
	pregID INTEGER NOT NULL,
	PRIMARY KEY (coupleID,pregID),
	FOREIGN KEY(coupleID) REFERENCES COUPLE ON DELETE CASCADE,
	FOREIGN KEY(pregID) REFERENCES PREGNANCY ON DELETE CASCADE
);

CREATE TABLE MEDICAL_TEST
(
	testID INTEGER NOT NULL,
	prescribed_date DATE,
	sample_taken_date DATE NOT NULL,
	performed_labwork_date DATE,
	test_sample VARCHAR(20) NOT NULL, --blood
	test_type VARCHAR(20) NOT NULL, --thyroid test
	test_result VARCHAR(20),
	technicianID INTEGER,
	technicianName VARCHAR(20),
	technicianPhonenum VARCHAR(15),
	pregID INTEGER NOT NULL,
	PRIMARY KEY(testID),
	FOREIGN KEY(pregID) REFERENCES PREGNANCY ON DELETE CASCADE,
	CHECK(performed_labwork_date > prescribed_date)
);
       	

