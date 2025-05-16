LOAD DATA
INFILE 'Books.csv'
INTO TABLE Books
FIELDS TERMINATED BY ',' OPTIONALLY ECLOSED BY '"'
(
    BookID INTEGER EXTERNAL,
    BookTitle CHAR,
    AuthorName Char,
    BookPrice DECIMAL EXTERNAL,
    BookPublisher Char,
    BookPublicationDate DATE "YYYY-MM-DD",
    BookQuantity INTEGER EXTERNAL
)