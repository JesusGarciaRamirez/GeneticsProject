function [x,y,NVAR] = load_data_benchmark(dataset_name)
%myFun - Description
%
% getting dataset parameters without scalling the data
%
% Long description
%Get data from  dataset(Index) 
dataset_path=sprintf("TSPBenchmark/%s",dataset_name);
if (isfile(dataset_path))
    data = load(dataset_path);
    x=data(:,1);y=data(:,2);
    NVAR=size(data,1);

else
    print("The filename you provided is not a dataset")
end

end