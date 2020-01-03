function [best_fitness, best,last_gen] = run_ga_return(x, y, NIND, MAXGEN, NVAR, ELITIST,... 
    F_OPT, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, STOP_EPOCHS,StopCriteria)
% usage: run_ga(x, y, 
%               NIND, MAXGEN, NVAR, 
%               ELITIST, STOP_PERCENTAGE, 
%               PR_CROSS, PR_MUT, CROSSOVER)
% x, y: coordinates of the cities
% NIND: number of individuals   
% MAXGEN: maximal number of generations
% ELITIST: percentage of elite population
% STOP_PERCENTAGE: percentage of equal fitness (stop criterium)
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% CROSSOVER: the crossover operator
% STOP_EPOCHS: number of epochs to stop if the best fitness does not improve
% calculate distance matrix between each pair of cities

%STOP_CRIT:""
%

%%We return best vector which contains the best fitness at each generation to calculate efficiency


%{NIND MAXGEN NVAR ELITIST STOP_PERCENTAGE PR_CROSS PR_MUT CROSSOVER LOCALLOOP}


    GGAP = 1 - ELITIST;
    mean_fits=zeros(1,MAXGEN+1);
    worst=zeros(1,MAXGEN+1);
    % dist has the values of the distances between cities
    Dist=zeros(NVAR,NVAR);
    for i=1:size(x,1)
        for j=1:size(y,1)
            Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
        end
    end
    % initialize population
    Chrom=zeros(NIND,NVAR);
    for row=1:NIND
        Chrom(row,:)=path2adj(randperm(NVAR));
        %Chrom(row,:)=randperm(NVAR);
    end
    gen=0;
    
    % evaluate initial population
    ObjV = tspfun(Chrom,Dist);
    best=zeros(1,MAXGEN);

    Stop=0;
    N=25;%Wait 25 gen before checking StopCrit 
    %%Initialization best_stop
    % generational loop
    while (Stop~=1 && gen<=1000)
        
        sObjV=sort(ObjV);
        best(gen+1)=min(ObjV);
        minimum=best(gen+1);
        mean_fits(gen+1)=mean(ObjV);
        worst(gen+1)=max(ObjV);
        for t=1:size(ObjV,1)
            if (ObjV(t)==minimum)
                break;
            end
        end
        %%Stopping Criteria
        Stop = get_stop_criteria(Chrom, best, StopCriteria, N,F_OPT,MAXGEN);

        %assign fitness values to entire population
        FitnV=ranking(ObjV);
        %select individuals for breeding
        SelCh=select('sus', Chrom, FitnV, GGAP);
        %recombine individuals (crossover)
        SelCh = recombin(CROSSOVER,SelCh,PR_CROSS);
        SelCh=mutateTSP('inversion',SelCh,PR_MUT);
        %evaluate offspring, call objective function
        ObjVSel = tspfun(SelCh,Dist);
        %reinsert offspring into population
        [Chrom ,ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);
        if nnz(~ObjV)
            fprintf('Something went wrong\n');
        end        
        Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom,LOCALLOOP,Dist);
       
        %increment generation counter
        gen=gen+1;    
    end
    last_gen=gen; %% Number of generations performed before reaching stopping criteria 
    disp(last_gen)

    best_fitness = min(best(1:last_gen));
end

