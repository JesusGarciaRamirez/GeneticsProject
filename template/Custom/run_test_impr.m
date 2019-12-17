
function  run_test_impr(dataset_name,parameters)
%% We are going to use the following datasets as test datasets for our parameter configurations
% dataset_list=['rondrit016.tsp','rondrit048.tsp','rondrit070.tsp','rondrit127.tsp'];

%Getting the tables for each dataset
[x,y,NVAR]=load_data_benchmark(dataset_name); %%Load data without scalling
% test_impr(x,y,NVAR,dataset_name);
test_impr(x,y,NVAR,parameters,dataset_name)
fprintf("Finished tests \n")
end