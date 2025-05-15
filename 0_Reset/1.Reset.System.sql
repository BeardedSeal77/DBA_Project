-- Active: 1747205126731@@127.0.0.1@1521@XEPDB1@SYSTEM
-- Connection Settings
--  Group: DBA
--  Name: DBA SYSTEM 
--  Host: 127.0.0.1 
--  Port: 1521 
--  Username: system 
--  Password: password 
--  Database: XEPDB1

-- ============================
-- Terminate Active Sessions
-- ============================
BEGIN
    FOR session IN (
        SELECT SID, SERIAL# 
        FROM V$SESSION 
        WHERE USERNAME IN ('USER_VIEWER', 'USER_CLERK', 'USER_MANAGER')
    ) LOOP
        EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ''' || session.SID || ',' || session.SERIAL# || ''' IMMEDIATE';
    END LOOP;
END;
/
COMMIT;

-- ============================
-- Drop Users and Schemas
-- ============================
BEGIN
    FOR user_rec IN (
        SELECT USERNAME 
        FROM DBA_USERS 
        WHERE USERNAME IN ('USER_VIEWER', 'USER_CLERK', 'USER_MANAGER')
    ) LOOP
        EXECUTE IMMEDIATE 'DROP USER ' || user_rec.USERNAME || ' CASCADE';
    END LOOP;
END;
/
COMMIT;

-- ============================
-- Drop Roles
-- ============================
BEGIN
    FOR role_rec IN (
        SELECT ROLE 
        FROM DBA_ROLES 
        WHERE ROLE IN ('BOOKSTORE_READ_ONLY', 'BOOKSTORE_DATA_ENTRY', 'BOOKSTORE_MANAGER')
    ) LOOP
        EXECUTE IMMEDIATE 'DROP ROLE ' || role_rec.ROLE;
    END LOOP;
END;
/
COMMIT;

-- ============================
-- Drop Public Synonyms
-- ============================
BEGIN
    FOR synonym_rec IN (
        SELECT SYNONYM_NAME 
        FROM DBA_SYNONYMS 
        WHERE TABLE_OWNER = 'PUBLIC' AND SYNONYM_NAME LIKE 'TBL%'
    ) LOOP
        EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ' || synonym_rec.SYNONYM_NAME;
    END LOOP;
END;
/
COMMIT;

-- ============================
-- Drop Custom Profile
-- ============================
DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists 
    FROM DBA_PROFILES 
    WHERE PROFILE = 'BOOKSTORE_PROFILE';
    
    IF v_exists > 0 THEN
        EXECUTE IMMEDIATE 'DROP PROFILE BOOKSTORE_PROFILE CASCADE';
    END IF;
END;
/
COMMIT;

-- ============================
-- Confirmation
-- ============================
PROMPT Database reset is complete. All users, roles, synonyms, and the custom profile have been removed.
