-- Active: 1747217122266@@127.0.0.1@1521@XEPDB1@USER_MANAGER
-- Connection Settings
--  Group: DBA
--  Name: DBA User_Manager 
--  Host: 127.0.0.1 
--  Port: 1521 
--  Username: user_manager 
--  Password: Manager#2025 
--  Database: XEPDB1

---------------------------------------------------------------------------------
-- 1) Log in as user_manager and create the tables
-- In SQL*Plus, you would do:
-- sqlplus user_manager/Manager#2025@127.0.0.1/XEPDB1
-- DISCONNECT;
-- CONNECT user_manager/Manager#2025@127.0.0.1/XEPBD1;

-- Verify the connection
SELECT USER FROM dual;

---------------------------------------------------------------------------------
---------------------------------Permissions-------------------------------------
---------------------------------------------------------------------------------
-- Grant Permissions on the Tables
-- Read-only role
GRANT SELECT ON tblAuthor       TO bookstore_read_only;
GRANT SELECT ON tblBook         TO bookstore_read_only;
GRANT SELECT ON tblBookAuthor   TO bookstore_read_only;
GRANT SELECT ON tblCustomer     TO bookstore_read_only;
GRANT SELECT ON tblOrder        TO bookstore_read_only;
GRANT SELECT ON tblOrderDetail  TO bookstore_read_only;

-- Data entry role
GRANT SELECT, INSERT, UPDATE ON tblAuthor       TO bookstore_data_entry;
GRANT SELECT, INSERT, UPDATE ON tblBook         TO bookstore_data_entry;
GRANT SELECT, INSERT, UPDATE ON tblBookAuthor   TO bookstore_data_entry;
GRANT SELECT, INSERT, UPDATE ON tblCustomer     TO bookstore_data_entry;
GRANT SELECT, INSERT, UPDATE ON tblOrder        TO bookstore_data_entry;
GRANT SELECT, INSERT, UPDATE ON tblOrderDetail  TO bookstore_data_entry;

-- Manager role
GRANT SELECT, INSERT, UPDATE, DELETE ON tblAuthor       TO bookstore_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblBook         TO bookstore_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblBookAuthor   TO bookstore_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblCustomer     TO bookstore_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblOrder        TO bookstore_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblOrderDetail  TO bookstore_manager;

---------------------------------------------------------------------------------
---------------------------------Verification------------------------------------
---------------------------------------------------------------------------------
-- Verify permissions
SELECT table_name, privilege, grantee
FROM all_tab_privs 
WHERE grantee IN ('BOOKSTORE_READ_ONLY', 'BOOKSTORE_DATA_ENTRY', 'BOOKSTORE_MANAGER')
ORDER BY table_name, grantee;

-- Verify Synonyms
SELECT * FROM ALL_SYNONYMS WHERE TABLE_OWNER = 'USER_MANAGER';

-- You can describe each table with:
-- DESCRIBE tblAuthor;
-- DESCRIBE tblBook;
-- DESCRIBE tblBookAuthor;
-- DESCRIBE tblCustomer;
-- DESCRIBE tblOrder;
-- DESCRIBE tblOrderDetail;