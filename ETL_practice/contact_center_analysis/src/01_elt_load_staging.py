import pandas as pd
from sqlalchemy import create_engine
import urllib

# 1. Cargamos el CSV crudo a la memoria de Pandas
df_operaciones = pd.read_csv('data/raw/raw_support_operations_data.csv')

# 2. Configuración de la conexión a SQL Server
nombre_servidor = 'GAV\SQLEXPRESS'  # Ejemplo: 'localhost' o '.\SQLEXPRESS'
nombre_bd = 'ContactsDB'

print("Conectando a SQL Server...")

# Creamos el string de conexión (Asegúrate de tener instalado el ODBC Driver 17 o 18 en Windows)
params = urllib.parse.quote_plus(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={nombre_servidor};DATABASE={nombre_bd};Trusted_Connection=yes;")
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

# 3. Inyección directa a la tabla Staging (La "L" de ELT)
print("Inyectando 10,000 registros en la tabla stg_support_operations...")

df_operaciones.to_sql('stg_support_operations',
                      con=engine,
                      if_exists='append',
                      index=False)

print("¡Carga masiva completada con éxito!")
