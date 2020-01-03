function test_path(x,y,NVAR,dataset_file)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description

MAXGEN=50;		% Maximum no. of generations
STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
NIND = 100;
ELITIST = .1;
LOCALLOOP = "";    %%Quitar local loop
STOP_EPOCHS = 100;
N_EXPERIMENTS = 10;
N_SAME_OP_EXPERIMENTS = 20;
PRMUT_INTERVAL = [0,.2];
PRCROSS_INTERVAL = [.5,1];
CROWDING = 0;
MAX_TIME = -1;
MEASURE_DIST = 0;


CROSS_OP = ["cross_mix","cross_ERX","cross_OX","cross_rand_sequential_constructive","cross_sequential_constructive"];
MUT_OP = ["mut_mix","mut_inverse3","mut_PSM","mut_RSM"];


%Casteamos a variables categoricas para poder meter estos parametros en la tabla
CROSS_OP_cat=categorical(CROSS_OP);
MUT_OP_cat=categorical(MUT_OP);



%%Name of the file to save table from experiment i
[ ~,filename, ~]=fileparts(dataset_file);
table_path=['Tuning/Results_' filename '.csv'];
eff_path=sprintf("Tuning/Eff_str%s.mat", filename);

%Initializations
%%Table
CROSS = "";MUT = "";PR_CROSS=0;PR_MUT=0;Av_Best=0;Peak_Best=0;Eff_1=0;
Results = table(CROSS,MUT,PR_CROSS,PR_MUT,Av_Best,Peak_Best,Eff_1);


%%Table
%Initialization=zeros(1,7);
%Results = array2table(Initialization,'VariableNames',{'CROSS','MUT','PR_CROSS','PR_MUT','Av_Best',...
                       % 'Peak_Best','Eff_1'});
%Total number of different parameter combinations
cont=0;

%%Structure to save efficiency curves
Eff_structure=struct;
Eff_vector_1=zeros(N_EXPERIMENTS,MAXGEN);
Eff_vector_2=zeros(N_EXPERIMENTS,MAXGEN);

Best_vector=zeros(1,N_EXPERIMENTS);



%%Performing Tests

% Same random prcross and prmut for all types of cross and mut
PR_CROSS = normalize(rand(1,N_SAME_OP_EXPERIMENTS), PRCROSS_INTERVAL);
PR_MUT = normalize(rand(1,N_SAME_OP_EXPERIMENTS), PRMUT_INTERVAL);

for i=1:length(CROSS_OP)
    for j=1:length(MUT_OP)
        for k=1:N_SAME_OP_EXPERIMENTS
            for n=1:N_EXPERIMENTS
                [Best_vector(n), best] = run_ga_return_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS(k), PR_MUT(k), CROSS_OP(i), MUT_OP(j), LOCALLOOP, STOP_EPOCHS, CROWDING, MAX_TIME, MEASURE_DIST);
                [Eff_vector_1(n,:),Eff_vector_2(n,:)]=get_efficiency(best,NIND);
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
            Results.CROSS(cont)=CROSS_OP_cat(i);
            Results.MUT(cont)=MUT_OP_cat(j);

            Results.PR_CROSS(cont)=PR_CROSS(k);
            Results.PR_MUT(cont)=PR_MUT(k);
            Results.Av_Best(cont)=Av_Best;
            Results.Peak_Best(cont)=Peak_Best; %%Me olvidaria del peak best

            % Results.Fit_var(cont)=Fit_var;
            Results.Eff_1(cont)=sum(Eff_vector_final_1) %%Area bajo la curva eff1, metrica ab de efficiency

            % Results.Eff_2(cont)=sum(Eff_vector_final_2); %%Esta variable no aporta nada en la tabla
            % Total: 5 * 4 * N_SAME_EXP * N_EXP = 400 iterations
            fprintf("Finished iter no. %d \n",cont)
        end
    end
end


%%Saving Table to file
writetable(Results,table_path)
%%Saving efficiency curves
save(eff_path,'Eff_structure')

end

function a = normalize(a, inter)
    a = a*(inter(2)-inter(1)) + inter(1);
end