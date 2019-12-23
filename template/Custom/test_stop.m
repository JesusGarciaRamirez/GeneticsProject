function test_stop(x,y,NVAR,parameters,dataset_file,rank_table)
    %myFun - Description
    %
    % Syntax: output = myFun(input)
    %   test_table =parameter combinations to test the stopping criterion i
    % Long description

   
    
    %%Loading Parameters
    MAXGEN=parameters.MAXGEN;		% Maximum no. of generations
    STOP_PERCENTAGE=parameters.STOP_PERCENTAGE;    % percentage of equal fitness individuals for stopping
    NIND =parameters.NIND;

    LOCALLOOP = parameters.LOCALLOOP;    %%Quitar local loop
    STOP_EPOCHS = parameters.STOP_EPOCHS;
    CROSSOVER=parameters.CROSSOVER;
    N_EXPERIMENTS = parameters.N_EXPERIMENTS;
    Criteria_list=["Crit1","Crit2","Crit3","Crit4","Crit5"];



    %%Name of the file to save table from experiment i
    [ ~,filename, ~]=fileparts(dataset_file);


    %%Read table with parameter combinations
    %%Read the normalised table and extract the parameter to perform anova
    table_path=sprintf("Ap1/%s",rank_table); 

    assert(isfile(table_path),"Wrong table path");

    par_comb=readtable(table_path);
                  
    %%Performing Tests
    for i=1:(height(par_comb))
        %%Loading parameter combination i from structure par_comb
        % NIND=par_comb.NIND(i);
        ELITIST=par_comb.ELITIST(i);
        PR_CROSS=par_comb.PR_CROSS(i);
        PR_MUT=par_comb.PR_MUT(i);
        %%Get F_Opt
        F_Opt=0.9*par_comb.Av_Best;

        %%Table
        stop_table_path=sprintf("Stop/Results_stop%d.csv",i);

        StopCrit = "";Av_Best=0;Last_gen=0;
        Results = table(Last_gen,Av_Best,StopCrit);

        for STOP_CRIT=1:length(Criteria_list)

            Best_vector=zeros(1,N_EXPERIMENTS);
            last_gen=zeros(1,N_EXPERIMENTS);

            %%Performing n set of equal experiments
            for n=1:N_EXPERIMENTS
                [Best_vector(n), ~,last_gen(n)] = run_ga_return(x, y, NIND,... 
                MAXGEN, NVAR, ELITIST, F_Opt, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, STOP_EPOCHS,STOP_CRIT);
                fprintf("Finished iter no. %d , %d iter remaining \n",n,N_EXPERIMENTS)
                last_gen(n)
            end

            %%Updating table
            Results.Last_gen(STOP_CRIT)=ceil(mean(last_gen));
            Results.Av_Best(STOP_CRIT)=mean(Best_vector);  
            Results.StopCrit(STOP_CRIT)=Criteria_list(STOP_CRIT)
          
      
        end
        %%Saving Table to file
        writetable(Results,stop_table_path)


        fprintf("Finished iter no. %d , %d iter remaining \n",i,height(par_comb))

    end
    end
