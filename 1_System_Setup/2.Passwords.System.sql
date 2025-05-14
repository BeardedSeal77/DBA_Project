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

-- Enforce Password Policies

-- Create a custom password profile named 'bookstore_profile'.
CREATE PROFILE bookstore_profile LIMIT
  FAILED_LOGIN_ATTEMPTS 5 -- Lock the account after 5 consecutive failed login attempts.
  PASSWORD_LIFE_TIME 90 -- Password must be changed every 90 days.
  PASSWORD_REUSE_TIME 180  -- Prevent the reuse of a password for 180 days after it's changed
  PASSWORD_LOCK_TIME 1 -- Automatically lock the account for 1 day after reaching the failed login limit
  PASSWORD_VERIFY_FUNCTION ora12c_verify_function; -- "ora12c_verify_function" enforces strong password rules (at least one uppercase, one digit, special char etc.)

-- Apply profile to users
ALTER USER user_viewer  PROFILE bookstore_profile;
ALTER USER user_clerk   PROFILE bookstore_profile;
ALTER USER user_manager PROFILE bookstore_profile;