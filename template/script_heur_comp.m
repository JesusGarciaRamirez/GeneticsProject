
dirs(1).dir="Ap1";
dirs(1).test_name="Ap1";
dirs(2).dir="Tuning";
dirs(2).test_name="Ours";

Dataset_name="rondrit127";

%%
dataset_list=["rondrit016","rondrit048","rondrit070","rondrit127"];
NIND=50;
for i=1:length(dataset_list)
    Dataset_name=dataset_list(i)
    compare_timeseries(dirs,Dataset_name,NIND)
  
end

%% Load Parameters (scal test Heuristics)
parameters.MAXGEN=30;		% Maximum no. of generations
parameters.STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
parameters.NIND=[20,50,80,100,120];
parameters.ELITIST=0.1;
parameters.LOCALLOOP="";    %%Quitar local loop
parameters.STOP_EPOCHS=150;
parameters.N_EXPERIMENTS=10;
parameters.CROSS_OP="cross_sequential_constructive";
parameters.MUT_OP="mut_RSM";
parameters.PR_MUT = .2;
parameters.PR_CROSS = .9;

parameters.IMPR = ["impr1","impr2","impr3","impr4","impr5",""];
parameters.base_dir="Heuristics";
%% Scal test, Heuristics
dataset_list=["rondrit070.tsp","rondrit127.tsp"];

for i=1:length(dataset_list)
    [x,y,NVAR]=load_data(dataset_list(i)); 
    test_impr_scal(x,y,NVAR,parameters,dataset_list(i));
end
%% Benchmark problems

bc_list=["bcl380.tsp","belgiumtour.tsp","rbx711.tsp","xqf131.tsp","xql662.tsp"];

bc_list="xqf131.tsp";
bc_list=["bcl380.tsp","belgiumtour.tsp","rbx711.tsp","xql662.tsp"];

for i=1:length(bc_list)
    bc_instance=bc_list(i);
    run_test_impr(bc_instance,parameters)
    
end
