function [best_fitness, best] = run_ga_return_path(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, MUTATION, LOCALLOOP, STOP_EPOCHS)
% usage: run_ga(x, y, 
%               NIND, MAXGEN, NVAR, 
%               ELITIST, STOP_PERCENTAGE, 
%               PR_CROSS, PR_MUT, CROSSOVER)
%               
%
%
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
%
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
        Chrom(row,:)=randperm(NVAR);
    end
    gen=0;
    % number of individuals of equal fitness needed to stop
    stopN=ceil(STOP_PERCENTAGE*NIND);
    % evaluate initial population
    ObjV = tspfun_path(Chrom,Dist);
    best=NaN(1,MAXGEN);
    % counter of epochs without chenge in the fittest
    change_cont = 0;
    
    % generational loop
    while gen<MAXGEN
        
        %sObjV=sort(ObjV);
        best(gen+1)=min(ObjV);
        minimum=best(gen+1);
        mean_fits(gen+1)=mean(ObjV);
        worst(gen+1)=max(ObjV);
        %
        %for t=1:size(ObjV,1)
        %    if (ObjV(t)==minimum)
        %        break;
        %    end
        %end
        
        % visualizeTSP(x,y,Chrom(t,:), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
        %
        %if (sObjV(stopN)-sObjV(1) <= 1e-15)
        %        break;
        %end          
        %assign fitness values to entire population
        FitnV=ranking(ObjV);
        %select individuals for breeding
        SelCh=select('sus', Chrom, FitnV, GGAP);
        %recombine individuals (crossover)
        SelCh = recombin_path(CROSSOVER,SelCh,PR_CROSS,Dist);
        SelCh=mutateTSP(MUTATION,SelCh,PR_MUT);
        %evaluate offspring, call objective function
        ObjVSel = tspfun_path(SelCh,Dist);
        if nnz(~ObjVSel)
            fprintf('something went really bad\n');      
        end
        %reinsert offspring into population
        [Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);
        
        Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom,LOCALLOOP,Dist);
        %increment generation counter
        gen=gen+1;    
        
    end
    best_fitness = min(best);
end
