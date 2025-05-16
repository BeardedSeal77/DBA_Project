import pandas as pd
import os
import cx_Oracle
import re
import sys
from datetime import datetime



# --------------------------DATA CLEANING-------------------------------

# Load and clean data from CSV file
def load_and_clean_data(csv_file_path):
    print("Loading CSV data...")
    try:
        df = pd.read_csv(csv_file_path)
    except Exception as e:
        print(f"Error loading CSV file: {str(e)}")
        sys.exit(1)
    
    print("Cleaning data...")
    
    # 1. Drop rows with duplicate book titles
    df.drop_duplicates(subset=['BookTitle'], inplace=True)
    
    # 2. Drop rows with empty author names
    df.dropna(subset=['AuthorName'], inplace=True)
    
    # 3. Clean author names (remove anything after comma)
    df['AuthorName'] = df['AuthorName'].apply(clean_author_name)
    
    # 4. Drop rows with special characters in title or author
    special_chars_mask = (
        df['BookTitle'].apply(has_special_chars) | 
        df['AuthorName'].apply(has_special_chars)
    )
    df = df[~special_chars_mask]
    
    # 5. Convert publication date format
    df['FormattedDate'] = df['BookPublicationDate'].apply(convert_date)
    
    print(f"Cleaned data: {len(df)} valid records")
    return df

# "Clean author names - remove anything after comma
def clean_author_name(name):
    if pd.isna(name):
        return name
    parts = name.split(',')
    return parts[0].strip()

# Convert date format from 'Mmm DD, YYYY' to Oracle date format
def convert_date(date_str):
    if pd.isna(date_str):
        return None
    try:
        date_obj = datetime.strptime(date_str.strip(), "%b %d, %Y")
        return date_obj
    except ValueError:
        # Handle other potential date formats here if needed
        return None

# Check for special characters in a string
def has_special_chars(text):
    if pd.isna(text):
        return False
    # This pattern matches any character that's not a letter, number, period, space, or common punctuation
    pattern = r'[^a-zA-Z0-9\s.,\-\'"]'
    return bool(re.search(pattern, text))



# --------------------------DATA LOADING-------------------------------

# Main function to import books from CSV to Oracle database
def import_books_to_database(csv_file_path, db_config):

    # Load and clean data
    df = load_and_clean_data(csv_file_path)
    
    # Connect to database
    connection, cursor = connect_to_database(
        db_config['username'], 
        db_config['password'], 
        db_config['dsn']
    )
    
    try:
        # Begin transaction
        print("Starting data import transaction...")
        
        # Process authors
        author_dict = process_authors(cursor, df)
        
        # Process books and relationships
        book_dict = process_books_and_relationships(cursor, df, author_dict)
        
        # Commit the transaction
        connection.commit()
        print("Data import completed successfully!")
        print(f"Imported {len(author_dict)} authors and {len(book_dict)} books.")
        
    except Exception as e:
        # Rollback in case of error
        connection.rollback()
        print(f"Error occurred during import: {str(e)}")
        raise
    
    finally:
        # Close cursor and connection
        cursor.close()
        connection.close()
        print("Database connection closed.")


# Establish connection to Oracle database
def connect_to_database(username, password, dsn):
    print("Connecting to database...")
    try:
        connection = cx_Oracle.connect(username, password, dsn)
        cursor = connection.cursor()
        return connection, cursor
    except Exception as e:
        print(f"Error connecting to database: {str(e)}")
        sys.exit(1)


# Process and insert authors into database
def process_authors(cursor, df):
    author_dict = {}
    unique_authors = df['AuthorName'].unique()
    print(f"Processing {len(unique_authors)} unique authors...")

    for author_name in unique_authors:
        try:
            # Check if the author already exists
            cursor.execute("SELECT AuthorID FROM tblAuthor WHERE AuthorName = :name", name=author_name)
            result = cursor.fetchone()

            if result:
                author_id = result[0]
            else:
                # If not found, insert the author and fetch the new ID
                cursor.execute("INSERT INTO tblAuthor (AuthorName) VALUES (:name)", name=author_name)
                cursor.execute("SELECT AuthorID FROM tblAuthor WHERE AuthorName = :name", name=author_name)
                author_id = cursor.fetchone()[0]

            author_dict[author_name] = author_id
            print(f"Author processed: {author_name} (ID: {author_id})")

        except Exception as e:
            print(f"Error inserting author '{author_name}': {str(e)}")
            raise
    
    return author_dict

# Process and insert books and author relationships into the junction table
def process_books_and_relationships(cursor, df, author_dict):
    print(f"Processing {len(df)} books and creating relationships...")

    book_dict = {}
    print(f"Processing {len(df)} books and creating relationships...")

    for index, row in df.iterrows():
        book_title = row['BookTitle']
        author_name = row['AuthorName']

        try:
            # Check if the book already exists
            cursor.execute("SELECT BookID FROM tblBook WHERE BookTitle = :title", title=book_title)
            result = cursor.fetchone()

            if result:
                book_id = result[0]
            else:
                # If not found, insert the book and fetch the ID
                cursor.execute(
                    """
                    INSERT INTO tblBook (BookTitle, BookPublisher, BookPublicationDate, BookPrice, BookQuantity)
                    VALUES (:title, :publisher, :pub_date, :price, :quantity)
                    """,
                    title=book_title,
                    publisher=row['BookPublisher'] if not pd.isna(row['BookPublisher']) else None,
                    pub_date=row['FormattedDate'],
                    price=row['BookPrice'] if not pd.isna(row['BookPrice']) else None,
                    quantity=row['BookQuantity'] if not pd.isna(row['BookQuantity']) else None
                )
                cursor.execute("SELECT BookID FROM tblBook WHERE BookTitle = :title", title=book_title)
                book_id = cursor.fetchone()[0]

            # Now insert into the junction table
            cursor.execute(
                """
                INSERT INTO tblBookAuthor (BookID, AuthorID) 
                VALUES (:book_id, :author_id)
                """,
                book_id=book_id,
                author_id=author_dict[author_name]
            )
            print(f"Linked book '{book_title}' with author '{author_name}'")

        except Exception as e:
            print(f"Error processing book '{book_title}': {str(e)}")
            raise
    
    return book_dict


# --------------------------Config-------------------------------
def main():
    # Configuration
    db_config = {
        "username": "user_manager",
        "password": "Manager#2025",
        "dsn": "localhost:1521/XEPDB1"  # host:port/service_name
    }   
    
    base_dir = os.path.dirname(os.path.abspath(__file__))
    csv_file_path = os.path.join(base_dir, "data", "Books.csv")
    
    try:
        import_books_to_database(csv_file_path, db_config)
    except Exception as e:
        print(f"Script execution failed: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()