LOAD DATA
INFILE 'Data/Books.csv'
INTO TABLE tblBook
APPEND
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  BookTitle,
  BookPublisher,
  BookPublicationDate DATE "DD-MON-YYYY",
  BookPrice,
  BookQuantity
)