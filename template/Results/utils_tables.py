import pandas as pd
import os
import numpy as np

import seaborn as sns
from pathlib import Path

# current_path=os.getcwd()
# tables=[table for table in os.listdir(current_path) if "csv" in table]


def get_new_tablename(table_name,process_type):
    path=Path(table_name)
    new_path=path.with_name(path.stem+ "_"+process_type +path.suffix)
    return new_path
pass


def rank_tables(tables,tables_path,parameters,criteria,n):
    #Reading tables
    table_list=[pd.read_csv(os.path.join(tables_path,table)) for table in tables]
    #Getting parameters
    rank_table=table_list[0].copy()

    rank_table=rank_table[parameters] ###Poner esto bien
    #Summing all criteria columns
    criteria_list=[el[criteria] for el in table_list]
    criteria_sum=sum(criteria_list)
    #Appending total criteria column to rank table
    rank_table=pd.concat([rank_table,criteria_sum],axis=1)
    #Ranking
    rank_table=rank_table.sort_values("M",ascending=False)
    return rank_table[:n] ## devolver los n mejores


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
