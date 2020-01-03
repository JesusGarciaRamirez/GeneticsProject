function test_benchmark_performance(x,y,NVAR,dataset_file, objective, time)


 MAXGEN=150;		% Maximum no. of generations (unused)
 NIND = 50;
 ELITIST = .1;
 N_EXPERIMENTS = 1;
 PR_MUT = .2;
 PR_CROSS = .9;

 CROSS_OP = "cross_sequential_constructive";
 MUT_OP = "mut_RSM";
 IMPR = ["impr3"];
 CROWDING = 0;
 MAX_TIME = time;
%Casteamos a variables categoricas para poder meter estos parametros en la tabla
IMPR_cat=categorical(IMPR);


%%Name of the file to save table from experiment i
[ ~,filename, ~]=fileparts(dataset_file);
table_path=sprintf("Res_Benchmark/Results_performance-%s-objective-%.2f.csv", filename, objective);

%Initializations
%%Table
Imp="";Av_Best=0;Epochs=0;Time=0;
Results = table(Imp,Av_Best,Epochs,Time);


%%Table
%Total number of different parameter combinations
cont=0;

times = zeros(1,N_EXPERIMENTS);
av_bests = zeros(1,N_EXPERIMENTS);
epochs = zeros(1,N_EXPERIMENTS);

%%Performing Tests
for i=1:length(IMPR)
    %%Creating struct for saving running res of each scal test(for diff NIND)

    for n=1:N_EXPERIMENTS
        [time, epoch, best, av_best] = run_ga_benchmark_performance(x, y, NIND, MAXGEN, NVAR, ELITIST, PR_CROSS, PR_MUT, CROSS_OP, MUT_OP, IMPR(i), CROWDING, MAX_TIME, objective);
        av_bests(n) = av_best;
        times(n) = time;
        epochs(n) = epoch;
        if time > MAX_TIME
            fprintf('Goal not reached in iteration %d', cont);
        end
    end
    cont=cont+1;

    
    Av_Best=mean(av_bests);
    Time = mean(times)
    Epochs = mean(epochs);
    
    %%"Appending" the results in a new row
    Results.Imp(cont)=IMPR_cat(i);
    Results.Av_Best(cont)=Av_Best;
    Results.Time(cont) = Time;
    Results.Epochs(cont) = Epochs;
    
    fprintf("Finished iter no. %d \n",cont)
end



%%Saving Table to file
writetable(Results,table_path)


end
