function test_basic(x,y,NVAR,parameters,exp_type,dataset_file)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description

% MAXGEN=100;		% Maximum no. of generations
% STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
% CROSSOVER = 'xalt_edges';  % default crossover operator
% NIND = [50, 100, 150,200];
% ELITIST = [0 .05 .1 .2];
% PR_CROSS = [.5 .7 .9 1];
% PR_MUT = [0 .05 .1 .2];
% LOCALLOOP = 0;    %%Quitar local loop
% N_EXPERIMENTS = 20;
% STOP_EPOCHS = 100;
% STOP_CRIT=false;

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
table_path=sprintf("Results/Results_%s_%s.csv",exp_type,filename);

eff_path=sprintf("Results/Eff_str%s.mat", filename);
%Initializations
%%Table
Initialization=zeros(1,9);
Results = array2table(Initialization,'VariableNames',{'NIND','ELITIST','PR_CROSS','PR_MUT','Av_Best',...
                        'Peak_Best','Fit_var','Eff_1','Eff_2'});

%Total number of different parameter combinations
cont=0;
%%Structure to save efficiency curves
% Eff_structure=struct;
Eff_vector_1=zeros(N_EXPERIMENTS,MAXGEN);
Eff_vector_2=zeros(N_EXPERIMENTS,MAXGEN);
%%Running Results
running_res=struct;
running_res.NIND=NIND;
running_results_path=sprintf("Results/Running_Res_%s.mat", filename);

%%Preallocation
best=zeros(N_EXPERIMENTS,MAXGEN);
Best_vector=zeros(1,N_EXPERIMENTS);

%%Performing Tests
for i=1:length(NIND)
    for j=1:length(ELITIST)
        for k=1:length(PR_CROSS)
            for l=1:length(PR_MUT)
                    for n=1:N_EXPERIMENTS
                        if(exp_type=="scal") %%Scalabilty experiments
                            [Best_vector(n), best(n,:),~,~] = run_ga_return(x, y, NIND(i), MAXGEN, NVAR, ELITIST(j), STOP_PERCENTAGE, PR_CROSS(k), PR_MUT(l), CROSSOVER, LOCALLOOP, STOP_EPOCHS,STOP_CRIT);
                            [Eff_vector_1(n,:),Eff_vector_2(n,:)]=get_efficiency(best(n,:),NIND(k));

                        else
                            [Best_vector(n), best,~,~] = run_ga_return(x, y, NIND(i), MAXGEN, NVAR, ELITIST(j), STOP_PERCENTAGE, PR_CROSS(k), PR_MUT(l), CROSSOVER, LOCALLOOP, STOP_EPOCHS,STOP_CRIT);
                            
                            [Eff_vector_1(n,:),Eff_vector_2(n,:)]=get_efficiency(best,NIND(i));

                        end

                    end
                    cont=cont+1;

                    %%Parameter update

                    Av_Best=mean(Best_vector);
                    Peak_Best=min(Best_vector); %The lower the fitness, the better

                    Fit_var=var(Best_vector);
                    Eff_vector_final_1=mean(Eff_vector_1); %%Final gr. efficiency haciendo av. efficiency de cada experimento
                    Eff_vector_final_2=mean(Eff_vector_2); %%Final gr. efficiency haciendo av. efficiency de cada experimento
                    
                    
                    %%Saving fitness/epochs results (Depends on type of exp)
                    if(exp_type=="scal")
                        ELITIST
                        PR_CROSS
                        PR_MUT
                        running_res.best{i}=mean(best);
                    end
                    %%"Appending" the results in a new row
                    Results.NIND(cont)=NIND(i);
                    Results.ELITIST(cont)=ELITIST(j);
                    Results.PR_CROSS(cont)=PR_CROSS(k);
                    Results.PR_MUT(cont)=PR_MUT(l);
                    Results.Av_Best(cont)=Av_Best;
                    Results.Peak_Best(cont)=Peak_Best;
                    Results.Fit_var(cont)=Fit_var;
                    Results.Eff_1(cont)=sum(Eff_vector_final_1); %%Area under eff1 curve
                    Results.Eff_2(cont)=sum(Eff_vector_final_2) %%Area under eff2 curve

                    fprintf("Finished iter no. %d \n",cont)
            end
        end
    end
end

%%Saving Table to file
writetable(Results,table_path)
%%Saving running results curves
if(exp_type=="scal")    
    save(running_results_path,'running_res')
end
end
