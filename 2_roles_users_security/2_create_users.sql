-- Create different users and assign their roles.

-- General viewer (read-only user).
CREATE USER user_viewer IDENTIFIED BY Viewer#2025;
GRANT CONNECT TO user_viewer;
GRANT bookstore_read_only TO user_viewer;

-- Data entry clerk (data entry user).
CREATE USER user_clerk IDENTIFIED BY Clerk#2025;
GRANT CONNECT TO user_clerk;
GRANT bookstore_data_entry TO user_clerk;

-- Admin staff (admin user).
CREATE USER user_manager IDENTIFIED BY Manager#2025;
GRANT CONNECT TO user_manager;
GRANT bookstore_manager TO user_manager;