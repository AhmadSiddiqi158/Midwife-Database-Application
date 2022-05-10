-- Include your drop table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the drop table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables has already been dropped (reverse of the creation order).

-- This is only an example of how you add drop table ddls to this file.
--   You may remove it.
--DROP TABLE MYTEST01;

DROP TABLE MOTHER;
DROP TABLE FATHER;
DROP TABLE COUPLE;
DROP TABLE HEALTHCARE_INSTITUTION;
DROP TABLE MIDWIFE;
DROP TABLE ONLINE_INFO_SESSION;
DROP TABLE SESSION_ATTENDANCE;
DROP TABLE PREGNANCY;
DROP TABLE PREGNANCY_MIDWIFE_ASSISTANCE;
DROP TABLE APPOINTMENT;
DROP TABLE NOTES;
DROP TABLE CHILD;
DROP TABLE EXPECTED_DATE;
DROP TABLE DUE_DATES;
DROP TABLE COUPLE_PREGNANCY;
DROP TABLE MEDICAL_TEST;
