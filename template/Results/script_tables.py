import pandas as pd
import os

current_path=os.getcwd()
tables=[table for table in os.listdir(current_path) if "csv" in table]

def table_processing(table_name,current_path):
    table_path=os.path.join(current_path,table_name)
    res_table=pd.read_csv(table_path)
    res_table=res_table.drop(columns=['NVAR', 'Fit_Var']) #Cleaning
    # Ordering
    ordered_table=res_table.sort_values("Av_Best",ascending=False)
    # Table of the fittest
    fittest_table=ordered_table[:10]
    #Getting new table name from "old" table name
    new_table_path= get_tablename(table_name)
    fittest_table.to_csv(new_table_path)
pass

def get_tablename(table_name):
    name=table_name.split(".")
    name_cropped=name[0]+"_Fittest."+name[1]
    return name_cropped
pass