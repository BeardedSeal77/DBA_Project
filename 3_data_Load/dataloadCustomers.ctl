LOAD DATA
INFILE 'Customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
    CustomerName CHAR,
    CustomerAddress Char,
    CustomerEmail CHAR
)