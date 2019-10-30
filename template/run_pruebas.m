
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

%%Loading Parameters
MAXGEN=100;		% Maximum no. of generations
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
CROSSOVER = 'xalt_edges';  % default crossover operator
NIND = [50, 100, 150];
ELITIST = [0 0.05 0.2];
PR_CROSS = [.5 .9 1];
PR_MUT = [0 .05 .2];
LOCALLOOP = [0 1];
N_EXPERIMENTS = 20;

%%Loading all datasets
datasets=load_datasets;

%%Getting Dataset (Index) to perform test
index=1; %Ej. First dataset
x,y,NVAR = load_data(index);

