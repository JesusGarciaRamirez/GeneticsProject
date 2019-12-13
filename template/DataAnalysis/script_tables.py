from utils_tables import *

import argparse

def get_parser():
    parser = argparse.ArgumentParser(description="Tables processing")
    parser.add_argument(
        "--table_name",
        help="name to table to process",
    )
    parser.add_argument(
        "--process_type",
        help="type of process",
    )
    parser.add_argument(
        "--par_type",
        help="Parameter to work with (can be CROSSOVER or MUT)",
    )
    return parser


def process_table_basic(table_name):
    #Path to table
    table_folder=os.getcwd()
    table_path=os.path.join(table_folder,table_name)
    #opening table
    assert os.path.isfile(table_path) , "Path not correctly defined"
    res_table=pd.read_csv(table_path)

    #Cleaning
    res_table=res_table.drop(columns={"Eff_2","Fit_var"})
    res_table["Av_Best"]=res_table["Av_Best"].apply(lambda x: 1/x)
    res_table["Peak_Best"]=res_table["Peak_Best"].apply(lambda x: 1/x)
    #Normalizing columns
    metric_list=["Av_Best","Eff_1"]
    norm_table=normalise_metrics(metric_list,res_table)

    # ##Getting final metric(average of metrics) and ranking
    norm_table['M'] = norm_table.apply(lambda row: (0.5*(row["Av_Best_unit"]+row["Eff_1_unit"])), axis=1)
    # norm_table.sort_values("M",ascending=False) #Get the best 10 values
    #Saving table
    final_table_name=get_new_tablename(table_name,"Fittest")
    table_path=os.path.join(table_folder,final_table_name)
    norm_table.to_csv(table_path)
    print("Correctly saved table  {0}".format(table_name))

def get_best_parameters(tuning_table,par_type): #Par_type can be "CROSSOVER" or "MUT"
    # #Make copy to work with
    # tuning_copy=tuning_table.copy()
    #Sorting and selecting 
    tuning_table=tuning_table.sort_values("Av_Best",ascending=False)
    best_cross_counts=tuning_table[par_type][:50].value_counts()
    return best_cross_counts.keys()

##Process Tuning Tables

table_list=[table for table in os.listdir(tuning_folder) if "csv" in table]
print(table_list)
tuning_dict={}
for table in table_list:
    #open table
    tuning_table=pd.read_csv(os.path.join(tuning_folder,table))
    
    #Av_Best (1/Av)
    tuning_table["Av_Best"]=tuning_table["Av_Best"].apply(lambda x: 1/x)
    #Normalize cols
    metric_list=["Av_Best"]
    tuning_table=normalise_metrics(metric_list,tuning_table)

    # #Getting best_cross 
    best_cross=get_best_parameters(tuning_table,"CROSS")
    tuning_table=tuning_table[tuning_table["CROSS"].isin(best_cross)]
    #append
    tuning_dict[table]=tuning_table
    #clear
    del tuning_table




if __name__ == "__main__":

    args = get_parser().parse_args()
    if (args.process_type=="basic"):
        process_table_basic(args.table_name)

    elif (args.process_type=="tuning"):
        
        get_best_parameters(tuning_table,args.par_type)
        pass

    # if args.type==1
    #     process_table
    # pass





    