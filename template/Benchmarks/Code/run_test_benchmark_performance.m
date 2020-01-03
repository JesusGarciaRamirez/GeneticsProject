

function  run_test_benchmark_performance(dataset_name, objective, time)
%Getting the tables for each dataset
[x,y,NVAR]=load_data_benchmark(dataset_name); %%Load data without scalling
test_benchmark_performance(x,y,NVAR,dataset_name, objective, time)
fprintf("Finished tests \n")
end