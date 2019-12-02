from utils_tables import *

import argparse

def get_parser():
    parser = argparse.ArgumentParser(description="Tables ranking")
    parser.add_argument(
        "--table_name",
        help="name to table to process",
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


if __name__ == "__main__":

    args = get_parser().parse_args()
    process_table_basic(args.table_name)

    # if args.type==1
    #     process_table
    # pass