import pandas as pd
from sqlalchemy import create_engine
import sys

connection_string = 'postgresql://postgres:Shritin15@localhost:5432/Clickstream_project'

try:
    engine = create_engine(connection_string)

    with engine.connect() as connection:
        print("Successfully connected to the PostgreSQL database!")
        
except Exception as e:
    print(f"Error connecting to the database: {e}")
    sys.exit()

#Loading the raw csv data into a pandas DataFrame
file_path = 'Online_Retail.csv'

try:
    df = pd.read_csv(file_path, encoding='ISO-8859-1')
except FileNotFoundError:
    print(f"Error: The file '{file_path}' was not found.")
    print("Please make sure the dataset is in the same folder as this Jupyter Notebook.")
    sys.exit()

#Cleaning and preparing the data
df.columns = df.columns.str.lower().str.replace(' ', '_').str.replace('.', '_')

#Loading the DataFrame into postgresql database 
try:
    df.to_sql('transactions', engine, if_exists='replace', index=False)
    print("\nData successfully loaded into the 'transactions' table!")

except Exception as e:
    print(f"\nError loading data to the database: {e}")