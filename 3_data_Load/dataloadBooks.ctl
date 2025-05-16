LOAD DATA
INFILE 'Books.csv'
INTO TABLE tblBook
FIELDS TERMINATED BY ',' OPTIONALLY ECLOSED BY '"'
(
    BookID,
    BookTitle,
    AuthorName,
    BookPrice,
    BookPublisher,
    BookPublicationDate DATE "YYYY-MM-DD",
    BookQuantity
)