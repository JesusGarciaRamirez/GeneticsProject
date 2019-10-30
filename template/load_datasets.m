function datasets = load_datasets()
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description
    % load the data sets
    datasetslist = dir('datasets/');datasetslist = dir('datasets/');
    datasets=cell( size(datasetslist,1)-2,1);datasets=cell( size(datasetslist,1)-2 ,1);
    for i=1:size(datasets,1);
        datasets{i} = datasetslist(i+2).name;
    end

end