import pandas as pd
import os
import numpy as np
from scipy.io import loadmat

import seaborn as sns
from pathlib import Path

# current_path=os.getcwd()
# tables=[table for table in os.listdir(current_path) if "csv" in table]




class cd:
    """Context manager for changing the current working directory"""
    def __init__(self, newPath):
        self.newPath = os.path.expanduser(newPath)

    def __enter__(self):
        self.savedPath = os.getcwd()
        os.chdir(self.newPath)

    def __exit__(self, etype, value, traceback):
        os.chdir(self.savedPath)

#Table functions
def get_new_tablename(table_name,process_type):
    path=Path(table_name)
    new_path=path.with_name(path.stem+ "_"+process_type +path.suffix)
    return new_path
pass


def rank_tables(df_dict,parameters,criteria="CritSum",n=3):

    criteria_list=[el[criteria] for el in df_dict.values()]
    criteria_sum=sum(criteria_list)
    
    rank_table=df_dict["rondrit127"].copy()[parameters]

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
            

        
##Auxiliary functions to work with .mat files(timeseries)
def load_matlab_ts(matfile,matfolder,Heur=False):
    """Aux function to load Running res struct from .mat files
        as a pandas df"""
    mat_str = loadmat(os.path.join(matfolder,matfile))
    NIND_vector=[20,50,80,100,120]
    items=[item for item in mat_str['running_res'][0][0]]
    fit_values=[items[1].flat[i] for i in range(items[1].shape[1])]
    # Data
    #Create dict from ts data
    ts_dict={}
    ts_dict["epoch"]=range(fit_values[1].shape[1])

    # for i,NIND in enumerate(NIND_vector):
    #     if(Heur==True):
    #         #Heuristics case : each col is fit values for each impr (same NIND)
    #         ts_dict["IMPR{0}".format(i)]=fit_values[i].flatten()
    #     else:
    #         ##Basic case /Stop criteria/Tuning case: each col is fit values for NIND 
    #         ts_dict["{0}".format(NIND)]=fit_values[i].flatten()

    if(Heur==True):
        for i in range(len(fit_values)):
            ts_dict["IMPR{0}".format(i)]=fit_values[i].flatten()

    else:
        for NIND in NIND_vector:
            ts_dict["{0}".format(NIND)]=fit_values[i].flatten()

    return pd.DataFrame(ts_dict)


def import_ts_data(scal_path,Heur=False): #Get dict with ts results(values) for each dataset(keys) in scal dir (eg.Tuning)

    ts_files=[file for file in os.listdir(scal_path) if ("Running_Res" in file) and  (".mat" in file)]
    dict_ts={}
    for file in ts_files:
        Dataset=file.split("Running_Res")[1].split("_")[1]
        dict_ts[Dataset]=load_matlab_ts(file,scal_path,Heur)
    return dict_ts
    
def get_scal_heuristics(epochs,ts_files,scal_path,IMPR="IMPR4"):
    NIND_arr=[20,50,80,100,120]
    df_dict={}
    df_dict["epoch"]=range(epochs)
    for el in zip(ts_files,NIND_arr):
        matfile=el[0]
        NIND=el[1]
        ts_df=load_matlab_ts(matfile,scal_path,Heur=True)
        y=pd.Series(ts_df[IMPR],name="y")
        df_dict["y_{0} ind".format(NIND)]=y
        del ts_df
    return pd.DataFrame(df_dict)

def plot_ts_scal(Dataset,dict_ts,ax):
#     matfile=next((s for s in ts_files if Dataset in s), None)
#     ts_df=load_matlab_ts(matfile,scal_path,Heur=False)
    ts_df=dict_ts[Dataset]
    
    for col in ts_df.columns[1:]:
        ax.plot( 'epoch', col, data=ts_df, marker='', linewidth=1.5)
        
    ax.set(xlabel='Epochs', ylabel='Fitness',
       title=" Results {0}".format(Dataset))
    
    ax.grid(True)
    ax.legend()
    
    
