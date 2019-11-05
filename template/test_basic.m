function perform_tests(x,y,NVAR,Index)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description

%%Loading Parameters
MAXGEN=100;		% Maximum no. of generations
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
CROSSOVER = 'xalt_edges';  % default crossover operator
NIND = [50, 100, 150];
ELITIST = [0 0.05 0.2];
PR_CROSS = [.5 .9 1];
PR_MUT = [0 .05 .2];
LOCALLOOP = [0 1];
N_EXPERIMENTS = 20;
STOP_EPOCHS = 100;

cont=0;%Total number of different parameter combinations

%%Name of the file to save table from experiment i 
file_name=sprintf("Results/Results_Dataset_%d.csv", Index);


%Creating Empty Table for Results
Initialization=zeros(1,9);
Results = array2table(Initialization,'VariableNames',{'NIND','ELITIST','PR_CROSS','PR_MUT','LOCALLOOP','Av_Best',...
                        'Peak_Best','Fit_var'});
for i=1:length(NIND)
    for j=1:length(ELITIST)
        for k=1:length(PR_CROSS)
            for l=1:length(PR_MUT)
                for m=1:length(LOCALLOOP)
                    for n=1:N_EXPERIMENTS
                        [Best_vector(n), ~] = run_ga_return(x, y, NIND(i), MAXGEN, NVAR, ELITIST(j), STOP_PERCENTAGE, PR_CROSS(k), PR_MUT(l), CROSSOVER, LOCALLOOP(m), STOP_EPOCHS);
                    end
                    cont=cont+1;
                    Av_Best=mean(Best_vector);
                    Peak_Best=min(Best_vector); %The lower the fitness, the better
                    Fit_var=var(Best_vector);
                    %%"Appending" the results in a new row 
                    Results.NIND(cont)=NIND(i);
                    Results.ELITIST(cont)=ELITIST(j);
                    Results.PR_CROSS(cont)=PR_CROSS(k);
                    Results.PR_MUT(cont)=PR_MUT(l);
                    Results.LOCALLOOP(cont)=LOCALLOOP(m);
                    Results.Av_Best(cont)=Av_Best;
                    Results.Peak_Best(cont)=Peak_Best;
                    Results.Fit_var(cont)=Fit_var;
                    fprintf('Average best , Peak best  and Variance= \t %f , %f ,  %f #iteration = %d \n',Av_Best,Peak_Best,Fit_var,cont)
                end
            end
        end
    end
end

%Saving Table to file
writetable(Results,file_name)

end