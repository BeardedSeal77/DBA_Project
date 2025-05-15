import os
import sys
import pandas as pd
import cx_Oracle

def main():
    # Configuration
    db_config = {
        "username": "user_manager",
        "password": "Manager#2025",
        "dsn": "127.0.0.1:1521/XEPDB1"
    }

    base_dir = os.path.dirname(os.path.abspath(__file__))
    csv_file_path = os.path.join(base_dir, "data", "Customers.csv")

    try:
        connection, cursor = connect_to_database(db_config["username"], db_config["password"], db_config["dsn"])
        insert_customers(connection, cursor, csv_file_path)
    except Exception as e:
        print(f"Script execution failed: {str(e)}")
        sys.exit(1)
    finally:
        cursor.close()
        connection.close()

def connect_to_database(username, password, dsn):
    connection = cx_Oracle.connect(username, password, dsn)
    cursor = connection.cursor()
    return connection, cursor

def insert_customers(connection, cursor, csv_file_path):
    df = pd.read_csv(csv_file_path)

    for index, row in df.iterrows():
        cursor.execute(
            """
            INSERT INTO tblCustomer (CustomerName, CustomerAddress, CustomerEmail)
            VALUES (:name, :address, :email)
            """,
            {
                "name": row["CustomerName"].strip(),
                "address": row["CustomerAddress"].strip(),
                "email": row["CustomerEmail"].strip()
            }
        )

    connection.commit()
    print("All customer records inserted successfully.")

if __name__ == "__main__":
    main()
