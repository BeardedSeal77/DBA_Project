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

---------------------------------------------------------------------------------
-- 2) Create Roles and Grant Permissions

-- Role for general read-only users.
CREATE ROLE bookstore_read_only;
GRANT CREATE SESSION TO bookstore_read_only;

-- Role for data entry users (no DDL).
CREATE ROLE bookstore_data_entry;
GRANT CREATE SESSION TO bookstore_data_entry;

-- Role for admin-level access. (full DDL and DML)
CREATE ROLE bookstore_manager;
GRANT CREATE SESSION TO bookstore_manager;

-- Grant additional object creation rights
GRANT CREATE TABLE      TO bookstore_manager;
GRANT CREATE VIEW       TO bookstore_manager;
GRANT CREATE PROCEDURE  TO bookstore_manager;
GRANT CREATE SEQUENCE   TO bookstore_manager;
GRANT CREATE TRIGGER    TO bookstore_manager;

---------------------------------------------------------------------------------
-- 3) Create Users and Grant Roles

-- General viewer (read-only user).
CREATE USER user_viewer IDENTIFIED BY Viewer#2025
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;
GRANT bookstore_read_only TO user_viewer;

-- Data entry clerk (data entry user).
CREATE USER user_clerk IDENTIFIED BY Clerk#2025
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;
GRANT bookstore_data_entry TO user_clerk;

-- Admin staff (admin user).
CREATE USER user_manager IDENTIFIED BY Manager#2025
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;

-- Give them the app role
GRANT bookstore_manager TO user_manager;
GRANT UNLIMITED TABLESPACE TO user_manager;

-- check what roles are granted to user_viewer
SELECT GRANTED_ROLE 
FROM DBA_ROLE_PRIVS 
WHERE GRANTEE = 'USER_VIEWER';


-- check the privledges of the bookstore_read_only role
SELECT PRIVILEGE 
FROM DBA_SYS_PRIVS 
WHERE GRANTEE = 'BOOKSTORE_READ_ONLY';
