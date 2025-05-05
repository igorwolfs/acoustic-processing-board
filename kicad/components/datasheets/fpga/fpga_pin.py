import os
import pandas as pd

# Determine this script’s directory, then build the CSV path
script_dir = os.path.dirname(os.path.abspath(__file__))
csv_path   = os.path.join(script_dir, 'FPGA-SC-02033-2-0-ECP5U-25-Pinout.csv')

# 1. Load the CSV, skipping the first 4 rows of metadata
df = pd.read_csv(csv_path,
                 skiprows=8,   # skip the metadata lines
                 header=0)     # treat the next line as header

# 2. Clean up column names
df.columns = (
    df.columns
      .str.strip()
      .str.replace(' ', '_')
      .str.lower()
)

print(df.columns)

pd.set_option('display.max_columns', 12)

# 3. Normalize the high_speed column to booleans
df['high_speed'] = (
    df['high_speed']
      .astype(str)
      .str.upper()
      .map({'TRUE': True, 'FALSE': False})
)

# Select only pins in bank 8
bank8 = df[df['bank'] == '2']
print(bank8)
print("Pins in Bank 2:")
print(bank8.shape[0])

filtered = df[df['dqs'].str.contains('RDQS', na=False)]
print(f"filtered: {filtered}")
# Select only pins for which high_speed is True
# highspeed = df[df['high_speed'] == True]
# print("\nPins with High Speed == True:")
# print(highspeed)
