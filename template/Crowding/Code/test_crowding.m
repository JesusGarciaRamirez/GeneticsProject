function test_crowding(x,y,NVAR,dataset_file)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description

MAXGEN=150;		% Maximum no. of generations
STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
NIND = 50;
ELITIST = .1;
STOP_EPOCHS = 250;
N_EXPERIMENTS = 20;
PR_MUT = .2;
PR_CROSS = .9;
CROSS_OP = "cross_sequential_constructive";
MUT_OP = "mut_RSM";
IMPR = "";
CROWDING = [0,1];

%%Name of the file to save table from experiment i
[ ~,filename, ~]=fileparts(dataset_file);
table_path=['Crowding/Results_' filename '.csv'];

%Initializations
%%Table
Crowd=0;Av_Best=0;Peak_Best=0;Std=0;Av_Dist=0;Equals=0;
Results = table(Crowd,Av_Best,Peak_Best,Std,Av_Dist,Equals);


%%Table
%Total number of different parameter combinations
cont=0;

%%Structure to save efficiency curves
Best_vector=zeros(1,N_EXPERIMENTS);
Standd_vector = zeros(1,N_EXPERIMENTS);
Distance = zeros(length(CROWDING),N_EXPERIMENTS,MAXGEN);
Best = zeros(length(CROWDING),N_EXPERIMENTS,MAXGEN);
Distance_av = zeros(length(CROWDING),MAXGEN);
Best_av = zeros(length(CROWDING),MAXGEN);
Equals_vector = zeros(1,N_EXPERIMENTS);



%%Performing Tests

for i=1:length(CROWDING)
    
    running_res=struct;
    running_res.CROWDING=CROWDING(i);
    
    
    for n=1:N_EXPERIMENTS
        [Best_vector(n), Best(i,n,:), foo, Standd_vector(n), Distance(i,n,:), Equals_vector(n)] = run_ga_return_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSS_OP, MUT_OP, IMPR, STOP_EPOCHS, CROWDING(i), -1, 1);
    end
    cont=cont+1;
    Standard_deviation = mean(Standd_vector);
    Av_Best=mean(Best_vector);
    Peak_Best=min(Best_vector); %The lower the fitness, the better
    % Best_vector_inv=1./(Best_vector); %%Transforming fitness
    % Fit_var=var(Best_vector_inv);
    %%"Appending" the results in a new row
    Results.Crowd(cont)=CROWDING(i);
    Results.Av_Best(cont)=Av_Best;
    Results.Std(cont)=Standard_deviation;
    Results.Peak_Best(cont)=Peak_Best; %%Me olvidaria del peak best
    Results.Av_Dist(cont)=mean(mean(Distance(i,:,:)));
    Results.Equals(cont) = mean(Equals_vector)
        
    d = Distance(i,:,:);
    Distance_av(i,:) = mean(d);
    b = Best(i,:,:);
    Best_av(i,:) = mean(b);
    
    running_res.best = Best_av(i,:);
    running_res.dist = Distance_av(i,:);

    name = sprintf("Crowding/running_res_crowding_file-%s-crowding-%d.mat",dataset_file,i);
    save(name','running_res')
    fprintf("Finished iter no. %d \n",cont)
end

%{
%Plot distances
leg = {};
figure;
for i=1:length(CROWDING)
    plot(1:MAXGEN,Distance_av(i,:));
    hold on;
    leg{i} = "crowding = " + CROWDING(i);
end
hold off;
legend(leg);
title('Crowding average distance between genes')
savefig('Crowding\crowding_distances.fig');

%Plot best
leg = {};
figure;
for i=1:length(CROWDING)
    plot(1:MAXGEN,Best_av(i,:));
    hold on;
    leg{i} = "crowding = " + CROWDING(i);
end
hold off;
legend(leg);
title('Crowding best fitness')
savefig('Crowding\crowding_best.fig');
%}


%%Saving Table to file
writetable(Results,table_path)


end
