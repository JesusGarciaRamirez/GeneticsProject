function [best_fitness, best,last_gen,best_stop,S] = run_ga_return(x, y, NIND, MAXGEN, NVAR, ELITIST,... 
    STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, STOP_EPOCHS,STOP_CRIT)
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
    % number of individuals of equal fitness needed to stop
    stopN=ceil(STOP_PERCENTAGE*NIND);
    % evaluate initial population
    ObjV = tspfun(Chrom,Dist);
    best=zeros(1,MAXGEN);
   
    %%Vector for storing last gen using stopping criterion i
    last_gen=MAXGEN *ones(1,2);
    %%Flags for stopping criteria
    flags_vector=logical(zeros(1,2));
    %%Desired flags : "Definir esto bien" en este ejemplo queremos que se cumplan todas las stop conditions
    desired_flags=get_flags(STOP_CRIT);
    
    eq_fit_gen=0;%%Contador de # equal fitness generations


    S_aux=7.5;
    cont_s=0;

    %%Initialization best_stop
    % generational loop
    while (gen<MAXGEN & ~(isequal(flags_vector,desired_flags)))
        
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
       

        %%Stopping Criterias (Only checked in case we specify at least one stopping criteria)
        if(~(STOP_CRIT=="false") & gen>0)
        %%Eq number of fit evaluations
            if((best(gen)-best(gen+1)<=0) ) 
                eq_fit_gen=eq_fit_gen+1;  
            else
                eq_fit_gen=0;
            end
            if((eq_fit_gen==15 && flags_vector(1)==false  && desired_flags(1)==true))
                last_gen(1)=gen+1;
                flags_vector(1)=true; 
            
            end
            %%Efficiency criteria
            %%Sacar absolute best
            % %%threshold %% creo que me la pela este criterio.
            % threshold=0.0005; %%Mejora un 1%
            % if(((best(gen+1)>(1/(1+threshold))*best(gen)) &&  flags_vector(2)==false && desired_flags(2)==true))
            %     last_gen(2)=gen+1;
            %     flags_vector(2)=true;    
            % end
            %%Diversity threshold
            %%Get av_ diversity
            S(gen)=calc_av_diversity(Chrom);
            if(S(gen)~=S_aux)
                S_aux=S(gen);
                cont_s=0;
            else
                cont_s=cont_s+1;
            end
            if(cont_s>5 &&  flags_vector(2)==false && desired_flags(2)==true) 
                last_gen(2)=gen+1;
                % best_stop(3)=min(best(1:last_gen(3)));
                flags_vector(2)=true;    
            end
        end

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

    best_stop=zeros(1,2);
    for i=1:length(last_gen)
        best_stop(i)=min(best(1:last_gen(i)));
    end 
    % ending = min(gen+1, MAXGEN); %% Number of generations performed before reaching stopping criteria 
    best_fitness = min(best);
end


function desired_flags= get_flags(STOP_CRIT)
    switch STOP_CRIT
        case "Equal"
            desired_flags=logical([1,0]);
        % case "Eff"
        %     desired_flags=logical([0,1,0]);
        case "Diversity"
            desired_flags=logical([0,1]);
        otherwise
            desired_flags=logical(ones(1,2));
    end
        
end





