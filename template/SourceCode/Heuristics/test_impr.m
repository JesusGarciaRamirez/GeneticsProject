function test_impr(x,y,NVAR,parameters,dataset_file)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description

% MAXGEN=150;		% Maximum no. of generations
% STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
% NIND = 50;
% ELITIST = .1;
% STOP_EPOCHS = 150;
% N_EXPERIMENTS = 20;
% PR_MUT = .2;
% PR_CROSS = .9;

% CROSS_OP = "cross_sequential_constructive";
% MUT_OP = "mut_RSM";
% IMPR = ["impr1","impr2","impr3","impr4","impr5",""];

MAXGEN=parameters.MAXGEN;		% Maximum no. of generations
STOP_PERCENTAGE=parameters.STOP_PERCENTAGE;    % percentage of equal fitness individuals for stopping
NIND =parameters.NIND;
ELITIST = parameters.ELITIST;
STOP_EPOCHS = parameters.STOP_EPOCHS;
N_EXPERIMENTS = parameters.N_EXPERIMENTS;
PR_CROSS=parameters.PR_CROSS;
PR_MUT=parameters.PR_MUT;

IMPR=parameters.IMPR;
MUT_OP=parameters.MUT_OP;
CROSS_OP=parameters.CROSS_OP;
base_dir=parameters.base_dir; %%Path to save the results



%Casteamos a variables categoricas para poder meter estos parametros en la tabla
IMPR_cat=categorical(IMPR);


%%Name of the file to save table from experiment i
[ ~,filename, ~]=fileparts(dataset_file);
table_path=sprintf("%s/Results_%s.csv",base_dir,filename);

eff_path=sprintf("Heuristics/Eff_str%s.mat", filename);

%Initializations
%%Table
Imp="";Av_Best=0;Peak_Best=0;Eff_1=0;NImprovements=0;
Results = table(Imp,Av_Best,Peak_Best,Eff_1,NImprovements);


%%Table
%Total number of different parameter combinations
cont=0;

%%Structure to save efficiency curves
Eff_structure=struct;
Eff_vector_1=zeros(N_EXPERIMENTS,MAXGEN);


%%Running Results
running_res=struct;
running_res.IMPR=IMPR;
running_results_path=sprintf("%s/Running_Res_%s.mat",base_dir, filename);

%%Preallocation
best=zeros(N_EXPERIMENTS,MAXGEN);
Best_vector=zeros(1,N_EXPERIMENTS);

%%Performing Tests
for i=1:length(IMPR)
    nimprovements = 0;
    for n=1:N_EXPERIMENTS
        [Best_vector(n), best(n,:), improvements] = run_ga_return_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSS_OP, MUT_OP, IMPR(i), STOP_EPOCHS);
        Eff_vector_1(n,:)=get_efficiency(best(n,:),NIND);
        nimprovements = nimprovements + sum(improvements);
    end
    cont=cont+1;
    running_res.best{i}=mean(best);

    Av_Best=mean(Best_vector);
    Peak_Best=min(Best_vector); %The lower the fitness, the better
    
    Eff_vector_final_1=mean(Eff_vector_1); %%Final gr. efficiency haciendo av. efficiency de cada experimento
    
    %%"Appending" the results in a new row
    Results.Imp(cont)=IMPR_cat(i);
    Results.Av_Best(cont)=Av_Best;
    Results.Peak_Best(cont)=Peak_Best; %%Me olvidaria del peak best

    % Results.Fit_var(cont)=Fit_var;
    Results.Eff_1(cont)=sum(Eff_vector_final_1); %%Area bajo la curva eff1, metrica ab de efficiency
    Results.NImprovements(cont) = nimprovements
    fprintf("Finished iter no. %d \n",cont)
end
save(running_results_path,'running_res')



%%Saving Table to file
writetable(Results,table_path)
%%Saving efficiency curves
save(eff_path,'Eff_structure')

end
