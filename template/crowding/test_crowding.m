function test_crowding(x,y,NVAR,dataset_file)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description

MAXGEN=150;		% Maximum no. of generations
STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
NIND = 50;
ELITIST = .1;
STOP_EPOCHS = 250;
N_EXPERIMENTS = 20;
PR_MUT = .2;
PR_CROSS = .9;
CROSS_OP = "cross_sequential_constructive";
MUT_OP = "mut_RSM";
IMPR = "";
CROWDING = [0,1];

%%Name of the file to save table from experiment i
[ ~,filename, ~]=fileparts(dataset_file);
table_path=['Crowding/Results_' filename '.csv'];

eff_path=sprintf("Crowding/Eff_str%s.mat", filename);

%Initializations
%%Table
Crowd=0;Av_Best=0;Peak_Best=0;Eff_1=0;Std=0;Av_Dist=0;Equals=0;
Results = table(Crowd,Av_Best,Peak_Best,Eff_1,Std,Av_Dist,Equals);


%%Table
%Total number of different parameter combinations
cont=0;

%%Structure to save efficiency curves
Eff_structure=struct;
Eff_vector_1=zeros(N_EXPERIMENTS,MAXGEN);
Best_vector=zeros(1,N_EXPERIMENTS);
Standd_vector = zeros(1,N_EXPERIMENTS);
Average_distance = zeros(1,N_EXPERIMENTS);
Equals_vector = zeros(1,N_EXPERIMENTS);



%%Performing Tests


for i=1:length(CROWDING)
    for n=1:N_EXPERIMENTS
        [Best_vector(n), best, foo, Standd_vector(n), Average_distance(n), Equals_vector(n)] = run_ga_return_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSS_OP, MUT_OP, IMPR, STOP_EPOCHS, CROWDING(i));
        Eff_vector_1(n,:)=get_efficiency(best,NIND);
    end
    cont=cont+1;
    Standard_deviation = mean(Standd_vector);
    Av_Best=mean(Best_vector);
    Peak_Best=min(Best_vector); %The lower the fitness, the better
    % Best_vector_inv=1./(Best_vector); %%Transforming fitness
    % Fit_var=var(Best_vector_inv);

    Eff_vector_final_1=mean(Eff_vector_1); %%Final gr. efficiency haciendo av. efficiency de cada experimento
    %%Saving curvas efficiency
    Eff_structure.curve_1{cont}=Eff_vector_final_1;
    %%"Appending" the results in a new row
    Results.Crowd(cont)=CROWDING(i);
    Results.Av_Best(cont)=Av_Best;
    Results.Std(cont)=Standard_deviation;
    Results.Peak_Best(cont)=Peak_Best; %%Me olvidaria del peak best
    Results.Av_Dist(cont)=mean(Average_distance);
    Results.Equals(cont) = mean(Equals_vector);

    % Results.Fit_var(cont)=Fit_var;
    Results.Eff_1(cont)=sum(Eff_vector_final_1)*100 %%Area bajo la curva eff1, metrica ab de efficiency
    fprintf("Finished iter no. %d \n",cont)
end


%%Saving Table to file
writetable(Results,table_path)
%%Saving efficiency curves
save(eff_path,'Eff_structure')

end
