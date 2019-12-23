function test_impr_2(x,y,NVAR,parameters,dataset_file)


 MAXGEN=150;		% Maximum no. of generations
 STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
 NIND = 50;
 ELITIST = .1;
 STOP_EPOCHS = 150;
 N_EXPERIMENTS = 20;
 PR_MUT = .2;
 PR_CROSS = .9;

 CROSS_OP = "cross_sequential_constructive";
 MUT_OP = "mut_RSM";
 IMPR = ["impr1","impr2","impr3","impr4","impr5",""];
 CROWDING = 0;
 MAX_TIME = 1;
 SAMPLES_SEC = 100;
%Casteamos a variables categoricas para poder meter estos parametros en la tabla
IMPR_cat=categorical(IMPR);


%%Name of the file to save table from experiment i
[ ~,filename, ~]=fileparts(dataset_file);
table_path=sprintf("Heuristics/Results_heuristics_time-%.2f_file-%s.csv", MAX_TIME, filename);

%Initializations
%%Table
Imp="";Av_Best=0;Peak_Best=0;NImprovements=0;
Results = table(Imp,Av_Best,Peak_Best,NImprovements);


%%Table
%Total number of different parameter combinations
cont=0;

Best_vector=zeros(1,N_EXPERIMENTS);

times = {};
bests = {};
time_steps = NaN(length(IMPR),SAMPLES_SEC*MAX_TIME);

%%Performing Tests
for i=1:length(IMPR)
    %%Creating struct for saving running res of each scal test(for diff NIND)
    running_res=struct;
    running_res.IMPR=IMPR_cat(i);
    
    nimprovements = 0;
    for n=1:N_EXPERIMENTS
        [Best_vector(n), best, improvements, foo, foo, foo, time] = run_ga_return_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSS_OP, MUT_OP, IMPR(i), STOP_EPOCHS, CROWDING, MAX_TIME, 0);
        nimprovements = nimprovements + sum(improvements);
        bests = [bests, best];
        times = [times, time];
    end
    cont=cont+1;

    time_steps(i,:) = get_avg_time_graph(bests,times,MAX_TIME,SAMPLES_SEC);
    running_res.best{i} = time_steps(i,:);
    
    Av_Best=mean(Best_vector);
    Peak_Best=min(Best_vector); %The lower the fitness, the better
        
    %%"Appending" the results in a new row
    Results.Imp(cont)=IMPR_cat(i);
    Results.Av_Best(cont)=Av_Best;
    Results.Peak_Best(cont)=Peak_Best; %%Me olvidaria del peak best

    % Results.Fit_var(cont)=Fit_var;
    Results.NImprovements(cont) = nimprovements
    fprintf("Finished iter no. %d \n",cont)
end

name = sprintf("Heuristics/running_res_time_secs-%.2f_file-%s.mat",MAX_TIME,dataset_file);
save(name','running_res')

%%Saving Table to file
writetable(Results,table_path)

%{
leg = {};
figure;
for i=1:length(IMPR)
    plot(1:MAX_TIME*SAMPLES_SEC,time_steps(i,:));
    hold on;
    leg{i} = "impr = " + IMPR(i);
end
hold off;
legend(leg);
title('Best fitness vs time')
savefig('Heuristics\time_vs_fitness.fig');
%}

end
