from utils_tables import *

import argparse

def get_parser():
    parser = argparse.ArgumentParser(description="Tables ranking")
    parser.add_argument(
        "table_name",
        help="name to table to process",
    )
    return parser

def process_table(table_name):
    table_folder=os.getcwd()
    table_path=os.path.join(table_folder,table_name)
    #opening table
    assert os.path.isfile(table_path) , "Path not correctly defined"
    res_table=pd.read_csv(table_path)
    res_table=res_table.drop(columns="Eff_Var")
    # res_table.head()
    #Normalizing columns
    metric_list=["Av_Best","Fit_var","Eff"]
    norm_table=normalise_metrics(metric_list,res_table)
    norm_table.head()
    ##Getting final metric(average of metrics) and ranking
    norm_table["sum"]=norm_table[["Av_Best_unit","Fit_var_unit","Eff_unit"]].sum(axis=1)
    final_table=norm_table.sort_values("sum",ascending=False)
    # final_table=final_table.drop(columns='Unnamed: 0')  ##we have to do this efficiently !
    #Saving table
    final_table_name=get_tablename(table_name)
    table_path=os.path.join(table_folder,final_table_name)
    final_table.to_csv(table_path)
    print("Correctly saved table  {0}".format(table_name))

if __name__ == "__main__":

    args = get_parser().parse_args()
    process_table(args.table_name)
    pass