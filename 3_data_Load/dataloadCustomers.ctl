LOAD DATA
INFILE 'Customers.csv'
INTO TABLE tblCustomer
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
    CustomerName,
    CustomerAddress,
    CustomerEmail
)