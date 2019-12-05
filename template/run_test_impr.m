
function  run_test_impr(dataset_name)
%% We are going to use the following datasets as test datasets for our parameter configurations
% dataset_list=['rondrit016.tsp','rondrit048.tsp','rondrit070.tsp','rondrit127.tsp'];

%Getting the tables for each dataset
[x,y,NVAR]=load_data(dataset_name); %%Getting Dataset (Index) to perform test
test_impr(x,y,NVAR,dataset_name);
fprintf("Finished tests \n")
end