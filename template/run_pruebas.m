% load the data sets
datasetslist = dir('datasets/');datasetslist = dir('datasets/');
datasets=cell( size(datasetslist,1)-2,1);datasets=cell( size(datasetslist,1)-2 ,1);
for i=1:size(datasets,1);
    datasets{i} = datasetslist(i+2).name;
end

% start with first dataset
data = load(['datasets/' datasets{1}]);
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);

%%Default parameters
%
% NIND=50;		% Number of individuals
MAXGEN=100;		% Maximum no. of generations
NVAR=26;		% No. of variables
% ELITIST=0.05;    % percentage of the elite population
% GGAP=1-ELITIST;		% Generation gap
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
% PR_CROSS=.95;     % probability of crossover
% PR_MUT=.05;       % probability of mutation
% LOCALLOOP=0;      % local loop removal
CROSSOVER = 'xalt_edges';  % default crossover operator

NIND = [50, 100, 150];
ELITIST = [0 0.05 0.2];
PR_CROSS = [.5 .9 1];
PR_MUT = [0 .05 .2];
LOCALLOOP = [0 1];
N_EXPERIMENTS = 5;
Best_vector=zeros(1,N_EXPERIMENTS)

for i=1:length(NIND)
    for j=1:length(ELITIST)
        for k=1:length(PR_CROSS)
            for l=1:length(PR_MUT)
                for m=1:length(LOCALLOOP)
                    for n=1:N_EXPERIMENTS
                        Best_vector(n) = run_ga_return(x, y, NIND(i), MAXGEN, NVAR, ELITIST(j), STOP_PERCENTAGE, PR_CROSS(k), PR_MUT(l), CROSSOVER, LOCALLOOP(m));
                    end
                    Best_vector
                    fprintf('average best = \t %f \n',mean(Best_vector))
                end
            end
        end
    end
end
%print('Best fitness: ' + best)