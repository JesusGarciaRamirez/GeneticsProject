function test_stop(x,y,NVAR,dataset_file,test_table,STOP_CRIT)
    %myFun - Description
    %
    % Syntax: output = myFun(input)
    %   test_table =parameter combinations to test the stopping criterion i
    % Long description

    %%Fixed parameters 
    MAXGEN=100;% Maximum no. of generations
    LOCALLOOP = 0;    %%Quitar local loop
    N_EXPERIMENTS = 20;
    STOP_PERCENTAGE=1;
    CROSSOVER = 'xalt_edges';  % default crossover operator
    STOP_EPOCHS = 100;

    %%Name of the file to save table from experiment i
    [ ~,filename, ~]=fileparts(dataset_file);
    test_table_path=['Results/Results_stop' filename '.csv'];
    
    % eff_path=sprintf("Stop/Eff_stop_str%s.mat", filename);
    % %%Structure to save efficiency curves
    % Eff_structure=struct;
    % % Eff_vector_1=zeros(N_EXPERIMENTS,MAXGEN);
    % % Eff_vector_2=zeros(N_EXPERIMENTS,MAXGEN);
    % Best_vector=zeros(1,N_EXPERIMENTS);
    
    %%Read table with parameter combinations
    %%Read the normalised table and extract the parameter to perform anova
    table_path= ['Results/' test_table];
    assert(isfile(table_path),"Wrong table path");
    par_comb=readtable(table_path);

    %%Table
    Initialization=zeros(1,5);
    Results = array2table(Initialization,'VariableNames',{'Test_id',...
                            'Av_Best_eq','Last_eq','Av_Best_div','Last_div'});
    %%Performing Tests
    for i=1:(height(par_comb))
        %%Loading parameter combination i from structure par_comb
        NIND=par_comb.NIND(i);
        ELITIST=par_comb.ELITIST(i);
        PR_CROSS=par_comb.PR_CROSS(i);
        PR_MUT=par_comb.PR_MUT(i);
        %%Performing n set of equal experiments
        for n=1:N_EXPERIMENTS
            [Best_vector(n), best,last_gen(n,:),best_stop(n,:),S] = run_ga_return(x, y, NIND,... 
            MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, STOP_EPOCHS,STOP_CRIT);
            % S(end)
            
            % % last_gen
            % % best_stop
            % best_idx=max(last_gen(n,:));
            % %%Si queremos plotear curvas van a dar problemas
            % [Eff_vector_1(n,:),Eff_vector_2(n,:)]=get_efficiency(best(1:best_idx),NIND);

        end
        %%Updating table
        Results.Test_id(i)=i;
        Results.Last_eq(i)=ceil(mean(last_gen(:,1)));
        Results.Av_Best_eq(i)=mean(best_stop(:,1));  
        Results.Last_div(i)=ceil(mean(last_gen(:,2)));
        Results.Av_Best_div(i)=mean(best_stop(:,2))
        % Results.Last_div(i)=ceil(mean(last_gen(:,3)));
        % Results.Av_Best_div(i)=mean(best_stop(:,3));

        fprintf("Finished iter no. %d , %d iter remaining \n",i,height(par_comb))

    end

    %%Saving Table to file
    writetable(Results,test_table_path)
    %%Saving efficiency curves
    % save(eff_path,'Eff_structure')
    end
