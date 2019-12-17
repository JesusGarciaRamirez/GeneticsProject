z%% Def parameters as a structure

parameters.MAXGEN=50;		% Maximum no. of generations
parameters.STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
parameters.NIND=50;
parameters.ELITIST=0.1;
parameters.LOCALLOOP="";    %%Quitar local loop
parameters.STOP_EPOCHS=100;
parameters.N_EXPERIMENTS=10;
parameters.CROSSOVER='xalt_edges';
parameters.STOP_CRIT="false";
parameters.PR_CROSS=0.5;
parameters.PR_MUT=0.5;

parameters.SameExp=15;

%%
parameters.NIND=[20,50,80,100,120];
parameters.MAXGEN=150;
parameters.STOP_EPOCHS=150;



%% Getting par comb using rank table (Scal Test)
exp_type="scal";
%%Read table with parameter combinations
%%Read the normalised table and extract the parameter to perform anova
rank_table="Ap1_rank_table.csv";
parameters_scal = get_parameters_scal(rank_table,parameters)
%% Run Tests


%%
parameters_scal.MAXGEN=50;		% Maximum no. of generations
parameters_scal.STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
parameters_scal.NIND=50;
parameters_scal.LOCALLOOP="";    %%Quitar local loop
parameters_scal.STOP_EPOCHS=100;
parameters_scal.N_EXPERIMENTS=10;
parameters_scal.CROSSOVER='xalt_edges';
parameters_scal.STOP_CRIT="false";

parameters_scal.SameExp=15;

%% Get intervals for parameters to be tuned
exp_type="Par_Comb";

PRCROSS_INTERVAL = [0.5,1];
PRMUT_INTERVAL = [0,0.5];
ELITIST_INTERVAL= [0,0.2];
N_Samples=parameters.SameExp;


parameters.PR_CROSS = normalize_custom(rand(1,N_Samples), PRCROSS_INTERVAL);
parameters.PR_MUT = normalize_custom(rand(1,N_Samples), PRMUT_INTERVAL);
parameters.ELITIST = normalize_custom(rand(1,4), ELITIST_INTERVAL);  %%Less samples(4) for ELITIST %


% %% Exp Changing #gen ,#ind (Rest parameters are set)
% parameters.PR_CROSS =0.9;
% parameters.MAXGEN =150;

% exp_type="scal"; %%For scalability

% parameters.NIND=[20,50,80,100,120];
%% Checking correct parameter set-up
parameters

%% Prueba  con small dataset
% dataset_list=["rondrit016.tsp","rondrit048.tsp","rondrit070.tsp","rondrit127.tsp"];
rank_table="Ap1_rank_table.csv";
dataset_list=["rondrit127.tsp"];

for i=1:length(dataset_list)
    %Getting the tables for each dataset
    dataset_name=dataset_list(i);
    [x,y,NVAR]=load_data(dataset_name); %%Getting Dataset (Index) to perform test
    test_scal_basic(x,y,NVAR,parameters,dataset_name,rank_table)

    fprintf("Finished set tests %d\n",i)
end
%% Correr tests para cada dataset (DEJAR FIJOS VALORES DE PARAMETERS)
% dataset_list=["rondrit016.tsp","rondrit048.tsp","rondrit070.tsp","rondrit127.tsp"];
dataset_list=["rondrit127.tsp"];
for i=1:length(dataset_list)
    %Getting the tables for each dataset
    dataset_name=dataset_list(i);
    [x,y,NVAR]=load_data(dataset_name); %%Getting Dataset (Index) to perform test
    test_basic(x,y,NVAR,parameters,exp_type,dataset_name);
    fprintf("Finished tests \n")
end






%% Update parameters struct using best par comb
function parameters_scal = get_parameters_scal(rank_table,parameters)
    parameters_scal=parameters;
    % rank_table="Ap1_rank_table.csv";

    table_path=sprintf("Results/%s",rank_table); 

    assert(isfile(table_path),"Wrong table path");

    par_comb=readtable(table_path);

    for i=1:(height(par_comb))
            parameters_scal.ELITIST(i)=par_comb.ELITIST(i);
            parameters_scal.PR_CROSS(i)=par_comb.PR_CROSS(i);
            parameters_scal.PR_MUT(i)=par_comb.PR_MUT(i);
    end
    parameters_scal.MAXGEN=150;		% Maximum no. of generations
    parameters_scal.STOP_EPOCHS=150;
    parameters_scal.NIND=[20,50,80,100,120];

end

