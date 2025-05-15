-- Example: Insert a new book with an author
BEGIN
    sp_insert_book_with_author(
        p_BookTitle          => 'Halo',
        p_AuthorName         => 'Eric Nylund',
        p_BookPublisher      => 'Allen Unwin',
        p_BookPublicationDate => TO_DATE('1937-09-21', 'YYYY-MM-DD'),
        p_BookPrice          => 19.99,
        p_BookQuantity       => 100
    );
END;
/
