LOAD DATA
INFILE 'Data/Customers.csv'
INTO TABLE tblCustomer
APPEND
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  CustomerName,
  CustomerAddress,
  CustomerEmail
)