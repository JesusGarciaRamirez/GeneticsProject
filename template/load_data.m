function [x,y,NVAR] = load_data(dataset_name)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description
%Get data from  dataset(Index) 

    dataset_path= ['datasets/' dataset_name];
    if (isfile(dataset_path))
        data = load(dataset_path);
        x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
        NVAR=size(data,1);

    else
        print("The filename you provided is not a dataset")
    end
end