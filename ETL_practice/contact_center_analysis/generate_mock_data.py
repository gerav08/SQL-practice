import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

# 1. Configuración inicial
num_registros = 10000
np.random.seed(42) # Para que siempre genere los mismos datos aleatorios si lo vuelves a correr

print(f"Generando {num_registros} registros operativos...")

# 2. Generación de Dimensiones Falsas (Opciones posibles)
canales = ['Voice', 'Chat', 'Email']
roles = ['Frontline', 'Tier 2 Escalations', 'Back-Office']
estados_escalamiento = ['Yes', 'No', 'Y', 'N', None] # Intencionalmente "sucio" para tu ETL

# 3. Construcción de columnas usando distribuciones matemáticas
# IDs de Ticket
ticket_ids = [f"INC-{10000 + i}" for i in range(num_registros)]

# Fechas (Simulando tickets generados en los últimos 6 meses)
fecha_inicio = datetime.now() - timedelta(days=180)
fechas = [fecha_inicio + timedelta(days=random.randint(0, 180), minutes=random.randint(0, 1440)) for _ in range(num_registros)]

# IDs de Agentes (Simulamos 50 agentes en la operación)
agent_ids = np.random.randint(1, 51, num_registros)

# Asignación de Canales (Probabilidad: 50% Voice, 30% Chat, 20% Email)
canales_asignados = np.random.choice(canales, num_registros, p=[0.5, 0.3, 0.2])

# Tiempos de Resolución en segundos (Handle Time) dependientes del canal
handle_times = []
for canal in canales_asignados:
    if canal == 'Voice':
        # Promedio de 8 minutos (480s) con variación normal
        ht = int(np.random.normal(480, 120))
    elif canal == 'Chat':
        # Promedio de 15 minutos (900s) porque atienden múltiples a la vez
        ht = int(np.random.normal(900, 200))
    else: # Email
        # Promedio de 25 minutos (1500s) para casos más de back-office o complejos
        ht = int(np.random.normal(1500, 300))
    handle_times.append(max(60, ht)) # Ningún ticket dura menos de 60 segundos

# Escalamientos (Aproximadamente un 15% de los tickets se escalan)
is_escalated_raw = np.random.choice(estados_escalamiento, num_registros, p=[0.10, 0.75, 0.03, 0.07, 0.05])

# Resolución (Si fue escalado o es muy corto, la probabilidad de resolución varía)
is_resolved = np.random.choice([True, False], num_registros, p=[0.85, 0.15])

# 4. Ensamblaje en la "Mesa de Trabajo" (DataFrame)
df_operaciones = pd.DataFrame({
    'Ticket_ID': ticket_ids,
    'Date_Created': fechas,
    'Agent_ID': agent_ids,
    'Channel_Type': canales_asignados,
    'Handle_Time_Secs': handle_times,
    'Escalated_Flag': is_escalated_raw,
    'Resolved': is_resolved
})

# 5. Exportación al Disco Duro
nombre_archivo = 'raw_support_operations_data.csv'
df_operaciones.to_csv(nombre_archivo, index=False)

print(f"¡Éxito! Archivo '{nombre_archivo}' generado en tu computadora con {len(df_operaciones)} filas.")

# Visualizamos las primeras 5 filas para comprobar
print("\nVista previa de los datos crudos:")
print(df_operaciones.head())