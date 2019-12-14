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


def rank_tables(df_dict,parameters,criteria="CritSum",n=3):

    criteria_list=[el[criteria] for el in df_dict.values()]
    criteria_sum=sum(criteria_list)
    
    rank_table=df_dict[next(iter(df_dict))].copy()[parameters]
    rank_table=pd.concat([rank_table,criteria_sum],axis=1).sort_values(criteria,ascending=False)[:3]
    return rank_table

def normalise_metrics(dataframe,metric_list):
    for metric in metric_list:
        column=dataframe[metric]
        if "Av" in metric:
            inv=True
        else:
            inv=False
        unit_column=unit_transform(column,inv)
        dataframe=pd.concat([dataframe,unit_column],axis=1)
    return dataframe

def unit_transform(column,inv=False):
    x_min=column.min()
    x_max=column.max()
    if(inv==True): #x_min -->1 ; x_max-->0
        unit_transform=[(x_min-el)/(x_max-x_min) +1 for el in column]
    else:   #x_min -->0 ; x_max-->1
        unit_transform=[(el-x_min)/(x_max-x_min) for el in column]

    return pd.Series(unit_transform,name=column.name + "_unit")

    
#Cleaning

##Cleaning


class table_class(object):
    """docstring for ClassName."""
    def __init__(self,table_file,dir_folder, exp_type,metric_list,cols=""):
        self.table_file=table_file
        self.exp_type=exp_type
        self.cols=cols
        self.metric_list=metric_list
        #Indirect parameters
        self.name=self.get_dataset_name()
        self.dataframe=pd.read_csv(os.path.join(dir_folder,table_file))

    def get_dataset_name(self):
        name, _ = os.path.splitext(self.table_file) 
        name_head="Results_"+ self.exp_type

        return name.split(name_head)[1]

    def create_dataset_col(self):
        dataset_name=self.get_dataset_name()
        return pd.Series([dataset_name for i in range(len(self.dataframe))],name="Dataset")

def create_tables(dir_folder,metric_list,exp_type=""):
    class_name_list=[name for name in os.listdir(dir_folder) if exp_type in name]
    #create class_list (as dict)
    class_dict={}

    for class_name in class_name_list:
        class_dict[class_name] = table_class(class_name,dir_folder,exp_type,metric_list)
        
    return class_dict
def get_best_parameters(df,par_type): #Par_type can be "CROSSOVER" or "MUT"
    # #Make copy to work with
    df_copy=df.copy()
    #Sorting and selecting 
    df_copy=df_copy.sort_values("CritSum",ascending=False)
    best_cross_counts=df_copy[par_type][:50].value_counts()
    return best_cross_counts.keys()

def table_pipeline_basic(tables_dict,drop=True):
    
    df_dict={}
    for key in tables_dict:
            #open table
            df=tables_dict[key].dataframe.copy()
            #Cleaning
            if(drop==True):
                df=df.drop(columns=tables_dict[key].cols)
            #Normalize cols
            df=normalise_metrics(df,tables_dict[key].metric_list)
            #Create Dataset & Sum of Metrics Col
            df["Dataset"]=df.apply(lambda row: tables_dict[key].name, axis=1)
            df["CritSum"]= df.apply(lambda row: (0.5*(row["Av_Best_unit"]+row["Eff_1_unit"])), axis=1)
            #append finalt table to dict
            df_dict[tables_dict[key].name]=df
            #Appending process df to the object
            tables_dict[key].dfprocess=df
            
    return df_dict

def table_pipeline_tuning(tables_dict):
    
    df_dict={}
    for key in tables_dict:
            #open table
            df=tables_dict[key].dataframe.copy()
            #Cleaning
            df=df.drop(columns=tables_dict[key].cols)
            #Normalize cols
            df=normalise_metrics(df,tables_dict[key].metric_list)
            #Create Dataset & Sum of Metrics Col
            df["Dataset"]=df.apply(lambda row: tables_dict[key].name, axis=1)
            df["CritSum"]= df.apply(lambda row: (0.5*(row["Av_Best_unit"]+row["Eff_1_unit"])), axis=1)
            #append finalt table to dict
            df_dict[tables_dict[key].name]=df
            #Appending process df to the object
            tables_dict[key].dfprocess=df
            
    return df_dict

def crop_table_best(tables_dict):
    df_dict={}
    for key in tables_dict.keys():
        df=tables_dict[key].copy()
        # #Getting best_cross 
        best_cross=get_best_parameters(df,"CROSS")
        df=df[df["CROSS"].isin(best_cross)]
        #append
        df_dict[key]=df
    return df_dict
        

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