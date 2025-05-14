-- Create the different roles.

-- Role for general read-only users.
CREATE ROLE bookstore_read_only;

-- Role for data entry users (staff who insert orders and customers).
CREATE ROLE bookstore_data_entry;

-- Role for admin-level access.
CREATE ROLE bookstore_manager;


-- Grant Object Privileges to the Roles.

-- bookstore_read_only: can only view data.
GRANT SELECT ON tblBook TO bookstore_read_only;
GRANT SELECT ON tblAuthor TO bookstore_read_only;
GRANT SELECT ON tblCustomer TO bookstore_read_only;
GRANT SELECT ON tblOrder TO bookstore_read_only;
GRANT SELECT ON tblOrderDetail TO bookstore_read_only;

-- bookstore_data_entry: can read and insert.
GRANT SELECT, INSERT ON tblCustomer TO bookstore_data_entry;
GRANT SELECT, INSERT ON tblOrder TO bookstore_data_entry;
GRANT SELECT, INSERT ON tblOrderDetail TO bookstore_data_entry;

-- bookstore_manager: assign read/write access.
GRANT SELECT, INSERT, UPDATE, DELETE ON tblBook TO bookstore_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblAuthor TO bookstore_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblCustomer TO bookstore_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblOrder TO bookstore_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON tblOrderDetail TO bookstore_manager;