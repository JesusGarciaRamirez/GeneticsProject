function test_impr(x,y,NVAR,dataset_file)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description

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

%Casteamos a variables categoricas para poder meter estos parametros en la tabla
IMPR_cat=categorical(IMPR);


%%Name of the file to save table from experiment i
[ ~,filename, ~]=fileparts(dataset_file);
table_path=['Heuristics/Results_' filename '.csv'];

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
Best_vector=zeros(1,N_EXPERIMENTS);



%%Performing Tests


for i=1:length(IMPR)
    nimprovements = 0;
    for n=1:N_EXPERIMENTS
        [Best_vector(n), best, improvements] = run_ga_return_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSS_OP, MUT_OP, IMPR(i), STOP_EPOCHS);
        Eff_vector_1(n,:)=get_efficiency(best,NIND);
        nimprovements = nimprovements + sum(improvements);
    end
    cont=cont+1;
    Av_Best=mean(Best_vector);
    Peak_Best=min(Best_vector); %The lower the fitness, the better
    % Best_vector_inv=1./(Best_vector); %%Transforming fitness
    % Fit_var=var(Best_vector_inv);

    Eff_vector_final_1=mean(Eff_vector_1); %%Final gr. efficiency haciendo av. efficiency de cada experimento
    %%Saving curvas efficiency
    Eff_structure.curve_1{cont}=Eff_vector_final_1;
    %%"Appending" the results in a new row
    Results.Imp(cont)=IMPR_cat(i);
    Results.Av_Best(cont)=Av_Best;
    Results.Peak_Best(cont)=Peak_Best; %%Me olvidaria del peak best

    % Results.Fit_var(cont)=Fit_var;
    Results.Eff_1(cont)=sum(Eff_vector_final_1)*100; %%Area bajo la curva eff1, metrica ab de efficiency
    Results.NImprovements(cont) = nimprovements
    fprintf("Finished iter no. %d \n",cont)
end


%%Saving Table to file
writetable(Results,table_path)
%%Saving efficiency curves
save(eff_path,'Eff_structure')

end
