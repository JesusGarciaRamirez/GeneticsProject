function [x,y,NVAR] = load_data(index,datasets)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description
%Get data from  dataset(Index) 
data = load(['datasets/' datasets{index}]);
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);
end