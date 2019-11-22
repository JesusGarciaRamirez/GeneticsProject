
%%Parameters definitions
% % NIND=50;		% Number of individuals
% MAXGEN=100;		% Maximum no. of generations
% NVAR=26;		% No. of variables
% % ELITIST=0.05;    % percentage of the elite population
% % GGAP=1-ELITIST;		% Generation gap
% STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
% % PR_CROSS=.95;     % probability of crossover
% % PR_MUT=.05;       % probability of mutation
% % LOCALLOOP=0;      % local loop removal
% CROSSOVER = 'xalt_edges';  % default crossover operator

%% We are going to use the following datasets as test datasets for our parameter configurations

dataset_list=['rondrit016.tsp','rondrit048.tsp','rondrit070.tsp','rondrit127.tsp'];

%Getting the tables for each dataset
for index = 1:length(dataset_list)
    dataset_name=dataset_list(index);
    [x,y,NVAR]=load_data(dataset_name); %%Getting Dataset (Index) to perform test
    perform_tests(x,y,NVAR,index);
    sprintf("Finished dataset %d",index)
end