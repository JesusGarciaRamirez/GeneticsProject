function test_scal_basic(x,y,NVAR,parameters,dataset_file,rank_table)
%myFun - Description
%
% Syntax: output = myFun(input)
%   rank_table =parameter combinations to test the stopping criterion i
% Long description


%%Loading Parameters
MAXGEN=parameters.MAXGEN;		% Maximum no. of generations
STOP_PERCENTAGE=parameters.STOP_PERCENTAGE;    % percentage of equal fitness individuals for stopping
NIND =parameters.NIND;

ELITIST = parameters.ELITIST;
LOCALLOOP = parameters.LOCALLOOP;    %%Quitar local loop
STOP_EPOCHS = parameters.STOP_EPOCHS;
STOP_CRIT=parameters.STOP_CRIT;
CROSSOVER=parameters.CROSSOVER;
N_EXPERIMENTS = parameters.N_EXPERIMENTS;
PR_CROSS=parameters.PR_CROSS;
PR_MUT=parameters.PR_MUT;


%%Name of the file to save table from experiment i
[ ~,filename, ~]=fileparts(dataset_file);
% rank_table_path=['Ap1/Results_scal' filename '.csv']

rank_table_path=sprintf("Ap1/Results_scal%s.csv",filename)

%%Read table with parameter combinations
%%Read the normalised table and extract the parameter to perform anova
table_path=sprintf("Results/%s",rank_table); 

assert(isfile(table_path),"Wrong table path");

par_comb=readtable(table_path);

%Initializations
%%Table
Initialization=zeros(1,6);
Results = array2table(Initialization,'VariableNames',{'Comb_idx','NIND','Av_Best',...
                        'Peak_Best','Fit_var','Eff_1'});

%Total number of different parameter combinations
cont=0;
%%Structure to save efficiency curves
% Eff_structure=struct;
Eff_vector_1=zeros(N_EXPERIMENTS,MAXGEN);
Eff_vector_2=zeros(N_EXPERIMENTS,MAXGEN);


%%Preallocation
best=zeros(N_EXPERIMENTS,MAXGEN);
Best_vector=zeros(1,N_EXPERIMENTS);
cont=0;
%%Performing Tests
for i=1:(height(par_comb))
    %%Loading parameter combination i from structure par_comb
    % NIND=parameters.NIND(i);

    ELITIST=par_comb.ELITIST(i);
    PR_CROSS=par_comb.PR_CROSS(i);
    PR_MUT=par_comb.PR_MUT(i);

    %%Creating struct for saving running res of each scal test(for diff NIND)
    running_res=struct;
    running_res.NIND=NIND;
    running_results_path=sprintf("Ap1/Running_Res_%s_%d.mat", filename,i);

    %%Running test for each of the diff parameter comb
    for k=1:length(NIND)
        cont=cont+1;
        for n=1:N_EXPERIMENTS
            [Best_vector(n), best(n,:),~,~] = run_ga_return(x, y, NIND(k), MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, STOP_EPOCHS,STOP_CRIT);
            [Eff_vector_1(n,:),Eff_vector_2(n,:)]=get_efficiency(best(n,:),NIND(k));
        end
        fprintf("Finished iter no. %d \n",k)

        running_res.best{k}=mean(best);

        Av_Best=mean(Best_vector);
        Peak_Best=min(Best_vector); %The lower the fitness, the better

        Fit_var=var(Best_vector);
        Eff_vector_final_1=mean(Eff_vector_1); %%Final gr. efficiency haciendo av. efficiency de cada experimento
        
        
        %%"Appending" the results in a new row
        Results.NIND(cont)=NIND(k);
        Results.Comb_idx(cont)=i;
        % Results.ELITIST(cont)=ELITIST;
        % Results.PR_CROSS(cont)=PR_CROSS;
        % Results.PR_MUT(cont)=PR_MUT;
        Results.Av_Best(cont)=Av_Best;
        Results.Peak_Best(cont)=Peak_Best;
        Results.Fit_var(cont)=Fit_var;
        Results.Eff_1(cont)=sum(Eff_vector_final_1)%%Area under eff1 curve


    end
    %%Save running_res (struct of timeseries) to .mat file
    save(running_results_path,'running_res')

   
end

%%Saving Table to file
writetable(Results,rank_table_path)

end
