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

-- Role for admin-level access. (full DDL and DML)
CREATE ROLE bookstore_manager;

-- Role for general read-only users.
CREATE ROLE bookstore_read_only;

-- Role for data entry users (no DDL).
CREATE ROLE bookstore_data_entry;



