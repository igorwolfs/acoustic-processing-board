import os
import pandas as pd

#  show *all* columns
pd.set_option('display.max_columns', None)

# don’t wrap or insert backslashes; use a very large width (or 0 for “no limit”)
pd.set_option('display.width', 0)           

# disable the expand-frame (multi-line) repr
pd.set_option('display.expand_frame_repr', False)

# Determine this script’s directory, then build the CSV path
script_dir = os.path.dirname(os.path.abspath(__file__))
csv_path   = os.path.join(script_dir, 'fpga_pinout.csv')

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

pd.set_option('display.max_columns', 12)

# 3. Normalize the high_speed column to booleans
df['high_speed'] = (
    df['high_speed']
      .astype(str)
      .str.upper()
      .map({'TRUE': True, 'FALSE': False})
)

print(df.columns)


df = df.drop(labels=['csfbga285', 'tqfp144', 'cabga381'], axis=1)

# Keep only pad numbers below 256
df = df[df['pad'] <= 256]

# keep only rows where cabga256 is not '-'
df = df[df['cabga256'] != '-']


# -- 1) To SELECT (keep) only the VCC‐pins:
condition_POWER_PINS = (
    df['pin/ball_function']
      .str.contains('VCC|VSS', case=False, na=False, regex=True)
)

power_pins = df[condition_POWER_PINS]
# condition = df['pin/ball_function'].str.contains('VCC', case=False, na=False, regex=False) | df['pin/ball_function'].str.contains('VSS', case=False, na=False, regex=False)
print(power_pins)