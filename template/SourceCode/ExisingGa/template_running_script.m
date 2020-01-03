%% Def parameters as a structure

parameters.MAXGEN=150;		% Maximum no. of generations
parameters.STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
parameters.NIND=50;
parameters.ELITIST=0.1;
parameters.LOCALLOOP="";    %%Quitar local loop
parameters.STOP_EPOCHS=150;
parameters.N_EXPERIMENTS=10;
parameters.SameExp=15;

parameters.CROSSOVER='xalt_edges';
parameters.MUT_OP="mut_RSM";
%%
dataset_file='rondrit016.tsp';
dataset_list=["rondrit016.tsp","rondrit048.tsp","rondrit070.tsp","rondrit127.tsp"];

for i=1:length(dataset_list)
    dataset_file=dataset_list(i);
    [x,y,NVAR]=load_data(dataset_file);
    rank_table="Ap1_rank_table.csv";
    test_stop(x,y,NVAR,parameters,dataset_file,rank_table)
end
%% Get intervals for parameters to be tuned
exp_type="PR_CROSS";

PRCROSS_INTERVAL = [0.8,1];
N_Samples=parameters.SameExp;

parameters.PR_CROSS = normalize_custom(rand(1,N_Samples), PRCROSS_INTERVAL);

%% Exp Changing #gen ,#ind (Rest parameters are set)
parameters.PR_CROSS =0.9;
parameters.MAXGEN =150;

exp_type="scal"; %%For scalability

parameters.NIND=[20,50,80,100,120];
%% Checking correct parameter set-up
parameters


%% Correr tests para cada dataset
dataset_list=["rondrit016.tsp","rondrit048.tsp","rondrit070.tsp","rondrit127.tsp"];

for i=1:length(dataset_list)
    %Getting the tables for each dataset
    dataset_name=dataset_list(i);
    [x,y,NVAR]=load_data(dataset_name); %%Getting Dataset (Index) to perform test
    test_path_x(x,y,NVAR,parameters,exp_type,dataset_name);
    fprintf("Finished tests \n")
end

%% 
function test_path_x(x,y,NVAR,parameters,exp_type,dataset_file)

%%Table Init
%%Table
CROSS = "";MUT = "";PR_CROSS=0;PR_MUT=0;NIND=0;Av_Best=0;Peak_Best=0;Eff_1=0;
Results = table(CROSS,MUT,PR_CROSS,PR_MUT,NIND,Av_Best,Peak_Best,Eff_1);

%%Parameters
MAXGEN=parameters.MAXGEN;		% Maximum no. of generations
STOP_PERCENTAGE=parameters.STOP_PERCENTAGE;    % percentage of equal fitness individuals for stopping
NIND =parameters.NIND;
ELITIST = parameters.ELITIST;
LOCALLOOP = parameters.LOCALLOOP;    %%Quitar local loop
STOP_EPOCHS = parameters.STOP_EPOCHS;
N_EXPERIMENTS = parameters.N_EXPERIMENTS;
N_SAME_OP_EXPERIMENTS = parameters.SameExp;

CROSS_OP=parameters.CROSS_OP;
MUT_OP=parameters.MUT_OP;

%%Name of the file to save table from experiment i
[ ~,filename, ~]=fileparts(dataset_file);

table_path=sprintf("Tuning/Results_%s_%s.csv",exp_type,filename);

% eff_path=sprintf("Tuning/Eff_str%s.mat", filename);



%Total number of different parameter combinations
cont=0;

%%Structure to save efficiency curves
% Eff_structure=struct;
Eff_vector_1=zeros(N_EXPERIMENTS,MAXGEN);
Eff_vector_2=zeros(N_EXPERIMENTS,MAXGEN);

Best_vector=zeros(1,N_EXPERIMENTS);
best=zeros(N_EXPERIMENTS,MAXGEN);
running_res=struct;
running_res.NIND=NIND;
running_results_path=sprintf("Tuning/Running_Res_%s.mat", filename);

% Same random prcross and prmut for all types of cross and mut
PR_CROSS=parameters.PR_CROSS;
PR_MUT=0.2;

%%Performing Tests
for k=1:length(NIND)
    for n=1:N_EXPERIMENTS
        [Best_vector(n), best(n,:)] = run_ga_return_path(x, y, NIND(k), MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSS_OP, MUT_OP, LOCALLOOP, STOP_EPOCHS);
        [Eff_vector_1(n,:),Eff_vector_2(n,:)]=get_efficiency(best(n,:),NIND(k));
    end
    cont=cont+1;
    %%Guardar vectores best durante test_run
    running_res.best{k}=mean(best);

    Av_Best=mean(Best_vector);   


    Peak_Best=min(Best_vector); %The lower the fitness, the better
    % Best_vector_inv=1./(Best_vector); %%Transforming fitness
    % Fit_var=var(Best_vector_inv);
    
    Eff_vector_final_1=mean(Eff_vector_1); %%Final gr. efficiency haciendo av. efficiency de cada experimento
    %%Saving curvas efficiency
    % Eff_structure.curve_1{cont}=Eff_vector_final_1;
    %%"Appending" the results in a new row
    Results.CROSS(cont)=CROSS_OP;
    Results.MUT(cont)=MUT_OP;
    Results.NIND(cont)=NIND(k);
    Results.PR_CROSS(cont)=PR_CROSS;
    Results.PR_MUT(cont)=PR_MUT;
    Results.Av_Best(cont)=Av_Best;
    Results.Peak_Best(cont)=Peak_Best; %%Me olvidaria del peak best

    % Results.Fit_var(cont)=Fit_var;
    Results.Eff_1(cont)=sum(Eff_vector_final_1) %%Area bajo la curva eff1, metrica ab de efficiency

    % Results.Eff_2(cont)=sum(Eff_vector_final_2); %%Esta variable no aporta nada en la tabla
    % Total: 5 * 4 * N_SAME_EXP * N_EXP = 400 iterations
    fprintf("Finished iter no. %d \n",cont)
end


%%Saving Table to file
writetable(Results,table_path)
%%Saving running_result curves
save(running_results_path,'running_res')

end

