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
GRANT CREATE SESSION TO bookstore_read_only;

-- Role for data entry users (no DDL).
GRANT CREATE SESSION TO bookstore_data_entry;

-- Role for admin-level access. (full DDL and DML)
GRANT CREATE SESSION TO bookstore_manager;

-- Grant additional object creation rights
GRANT CREATE TABLE      TO bookstore_manager;
GRANT CREATE VIEW       TO bookstore_manager;
GRANT CREATE PROCEDURE  TO bookstore_manager;
GRANT CREATE SEQUENCE   TO bookstore_manager;
GRANT CREATE TRIGGER    TO bookstore_manager;
GRANT CREATE PUBLIC SYNONYM TO bookstore_manager;

---------------------------------------------------------------------------------
-- 3) Grant Roles

-- General viewer (read-only user).
GRANT bookstore_read_only TO user_viewer;

-- Data entry clerk (data entry user).
GRANT bookstore_data_entry TO user_clerk;

-- Admin staff (admin user).
GRANT bookstore_manager TO user_manager;


