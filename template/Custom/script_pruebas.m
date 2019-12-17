

dataset_file='rondrit016.tsp';
[x,y,NVAR]=load_data(dataset_file);
%%Loading Parameters
MAXGEN=100;		% Maximum no. of generations
STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
CROSSOVER = 'xalt_edges';  % default crossover operator
NIND = 50;
ELITIST = 0 ;
PR_CROSS = 0.5;
PR_MUT = 0;
LOCALLOOP = 0;    %%Quitar local loop
N_EXPERIMENTS = 20;
STOP_EPOCHS = 100;

%%Name of the file to save table from experiment i
[ ~,filename, ~]=fileparts(dataset_file);
results_path=['Results/Results_ejemplo.csv'];

table_path=sprintf("Eff_str%s.mat", filename);
%Initializations
%%Table
Initialization=zeros(1,9);
Results = array2table(Initialization,'VariableNames',{'NIND','ELITIST','PR_CROSS','PR_MUT','Av_Best',...
                        'Peak_Best','Fit_var','Eff','Eff_Var'});

%Total number of different parameter combinations
cont=0;
%%Structure to save efficiency curves
Eff_structure=struct;

Eff_vector=zeros(N_EXPERIMENTS,MAXGEN);
% Eff_vector=struct;
for n=1:N_EXPERIMENTS
    [Best_vector(n), best] = run_ga_return(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, STOP_EPOCHS);
    % current_eff_vector=get_efficiency(best,NIND;
    Eff_vector(n,:)=get_efficiency(best,NIND);
end
cont=cont+1;
Av_Best=mean(Best_vector);
Peak_Best=min(Best_vector); %The lower the fitness, the better
Fit_var=var(Best_vector);

Eff_vector_final=mean(Eff_vector); %%Final gr. efficiency haciendo av. efficiency de cada experimento
%%Saving curvas efficiency
Eff_structure.curve{cont}=Eff_vector_final;
%%"Appending" the results in a new row
Results.NIND(cont)=NIND;
Results.ELITIST(cont)=ELITIST;
Results.PR_CROSS(cont)=PR_CROSS;
Results.PR_MUT(cont)=PR_MUT;
Results.Av_Best(cont)=Av_Best;
Results.Peak_Best(cont)=Peak_Best; %%Me olvidaria del peak best
Results.Fit_var(cont)=Fit_var;
Results.Eff(cont)=sum(Eff_vector_final); %%Area bajo la curva
Results.Eff_Var(cont)=var(Eff_vector_final);
fprintf("Finished iter no. %d \n",cont)


%%Saving Table to file
writetable(Results,results_path)
%%Saving efficiency curves
save(table_path,'Eff_structure')



%%

mat=cell2mat(struct2cell(Eff_vector.values));


