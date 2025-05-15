-- Active: 1747205126731@@127.0.0.1@1521@XEPDB1@SYSTEM
-- Connection Settings
--  Group: DBA
--  Name: DBA SYSTEM 
--  Host: 127.0.0.1 
--  Port: 1521 
--  Username: system 
--  Password: password 
--  Database: XEPDB1


-- 1) Connect to the database as SYSTEM
-- In SQL*Plus, you would run this:
-- sqlplus system/password@127.0.0.1/XEPDB1
-- CONNECT system/password@127.0.0.1/XEPDB1


-- Verify the connection
SELECT USER FROM dual;

-- 3) Create Users and Grant Roles

-- General viewer (read-only user).
CREATE USER user_viewer IDENTIFIED BY Viewer#2025
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;

-- Data entry clerk (data entry user).
CREATE USER user_clerk IDENTIFIED BY Clerk#2025
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;

-- Admin staff (admin user).
CREATE USER user_manager IDENTIFIED BY Manager#2025
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;
-- Give them the app role
GRANT CREATE TABLESPACE TO user_manager;
GRANT ALTER TABLESPACE TO user_manager;
GRANT DROP TABLESPACE TO user_manager;
GRANT UNLIMITED TABLESPACE TO user_manager;
GRANT CREATE TRIGGER TO user_manager;

