import pandas as pd

df = pd.read_excel('application/data/data_project_05.xlsx')

print(df['WheelBasedVehicleSpeed'].mean()+df['WheelBasedVehicleSpeed'].std())