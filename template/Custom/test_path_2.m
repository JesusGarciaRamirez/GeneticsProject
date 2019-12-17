function test_path_2(x,y,NVAR,parameters,exp_type,dataset_file)
%myFun - Description
%
% Testing Ga with best comb of MUT(RSM) and CROSS (Sequential_constructive)
% and keeping the PR_MUT to 0.2% (Best results)
%
% Long description

% MAXGEN=50;		% Maximum no. of generations
% STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
% NIND = 100;
% ELITIST = .1;
% LOCALLOOP = "";    %%Quitar local loop
% STOP_EPOCHS = 100;
% N_EXPERIMENTS = 10;
% N_SAME_OP_EXPERIMENTS = 20;
% % PRMUT_INTERVAL = [0,.2];
% % PRCROSS_INTERVAL = [.5,1];

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

%Initializations
%%Table
CROSS = "";MUT = "";PR_CROSS=0;PR_MUT=0;Av_Best=0;Peak_Best=0;Eff_1=0;
Results = table(CROSS,MUT,PR_CROSS,PR_MUT,Av_Best,Peak_Best,Eff_1);


%Total number of different parameter combinations
cont=0;

%%Structure to save efficiency curves
% Eff_structure=struct;
Eff_vector_1=zeros(N_EXPERIMENTS,MAXGEN);
Eff_vector_2=zeros(N_EXPERIMENTS,MAXGEN);

Best_vector=zeros(1,N_EXPERIMENTS);

% Same random prcross and prmut for all types of cross and mut
PR_CROSS=parameters.PR_CROSS;
PR_MUT=0.2;

%%Performing Tests
for k=1:N_SAME_OP_EXPERIMENTS
    
    for n=1:N_EXPERIMENTS
        [Best_vector(n), best] = run_ga_return_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS(k), PR_MUT, CROSS_OP, MUT_OP, LOCALLOOP, STOP_EPOCHS);
        [Eff_vector_1(n,:),Eff_vector_2(n,:)]=get_efficiency(best,NIND);
    end
    cont=cont+1;
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

    Results.PR_CROSS(cont)=PR_CROSS(k);
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
%%Saving efficiency curves
% save(eff_path,'Eff_structure')

end

