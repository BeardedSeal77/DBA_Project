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
-- procedure to add records to both books and authors
CREATE OR REPLACE PROCEDURE sp_insert_book_with_author(
    p_BookTitle          VARCHAR2,
    p_AuthorName         VARCHAR2,
    p_BookPublisher      VARCHAR2 DEFAULT NULL,
    p_BookPublicationDate DATE DEFAULT NULL,
    p_BookPrice          NUMBER DEFAULT NULL,
    p_BookQuantity       NUMBER DEFAULT NULL
) AS
    v_AuthorID NUMBER;
    v_BookID NUMBER;
BEGIN
    -- 1. Insert Author (if new) or get existing AuthorID
    BEGIN
        SELECT AuthorID INTO v_AuthorID 
        FROM tblAuthor 
        WHERE AuthorName = p_AuthorName;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO tblAuthor (AuthorName) 
            VALUES (p_AuthorName)
            RETURNING AuthorID INTO v_AuthorID;
    END;

    -- 2. Insert Book
    INSERT INTO tblBook (
        BookTitle, 
        BookPublisher, 
        BookPublicationDate, 
        BookPrice, 
        BookQuantity
    ) VALUES (
        p_BookTitle, 
        p_BookPublisher, 
        p_BookPublicationDate, 
        p_BookPrice, 
        p_BookQuantity
    ) RETURNING BookID INTO v_BookID;

    -- 3. Link them in tblBookAuthor
    INSERT INTO tblBookAuthor (BookID, AuthorID)
    VALUES (v_BookID, v_AuthorID);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Book and author inserted successfully!');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: your PC is going to explode maybe? IDK? ' || SQLERRM);
        RAISE;
END;
/