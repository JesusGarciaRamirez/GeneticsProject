import pandas as pd
import os
import numpy as np

import seaborn as sns
from pathlib import Path

# current_path=os.getcwd()
# tables=[table for table in os.listdir(current_path) if "csv" in table]

# def table_processing(table_name,current_path):
#     table_path=os.path.join(current_path,table_name)
#     res_table=pd.read_csv(table_path)
#     res_table=res_table.drop(columns=['NVAR', 'Fit_Var']) #Cleaning
#     # Ordering
#     ordered_table=res_table.sort_values("Av_Best",ascending=False)
#     # Table of the fittest
#     fittest_table=ordered_table[:10]
#     #Getting new table name from "old" table name
#     new_table_path= get_tablename(table_name)
#     fittest_table.to_csv(new_table_path)
# pass

def get_new_tablename(table_name,process_type):
    path=Path(table_name)
    new_path=path.with_name(path.stem+ "_"+process_type +path.suffix)
    return new_path
pass


def rank_tables(table_list,criteria):
    return


def normalise_metrics(metric_list,res_table):
    for metric in metric_list:
        column=res_table[metric]
        unit_column=unit_transform(column)
        res_table=pd.concat([res_table,unit_column],axis=1)
    return res_table

def unit_transform(column):
    x_min=column.min()
    x_max=column.max()
    unit_transform=[(el-x_min)/(x_max-x_min) for el in column]
    return pd.Series(unit_transform,name=column.name + "_unit")

    

##Plotting
# library
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt

def plot_3d(res_table,x,y,z):
    # Make the plot
    fig = plt.figure()
    ax = fig.gca(projection='3d')
    ax.plot_trisurf(res_table[y], res_table[x], res_table[z], cmap=plt.cm.viridis, linewidth=0.2)
    plt.show()
    
    # to Add a color bar which maps values to colors.
    surf=ax.plot_trisurf(res_table[y], res_table[x], res_table[z], cmap=plt.cm.viridis, linewidth=0.2)
    fig.colorbar(surf, shrink=0.5, aspect=5)
    plt.show()
    
    # Rotate it
    ax.view_init(30, 45)
    plt.show()
    
    # Other palette
    ax.plot_trisurf(res_table[y], res_table[x], res_table[z], cmap=plt.cm.jet, linewidth=0.01)
    plt.show()
