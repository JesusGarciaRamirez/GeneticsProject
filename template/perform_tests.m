function perform_tests()
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description
Best_vector=zeros(1,N_EXPERIMENTS);


for i=1:length(NIND)
    for j=1:length(ELITIST)
        for k=1:length(PR_CROSS)
            for l=1:length(PR_MUT)
                for m=1:length(LOCALLOOP)
                    for n=1:N_EXPERIMENTS
                        Best_vector(n) = run_ga_return(x, y, NIND(i), MAXGEN, NVAR, ELITIST(j), STOP_PERCENTAGE, PR_CROSS(k), PR_MUT(l), CROSSOVER, LOCALLOOP(m));
                    end
                    Av_Best=mean(Best_vector);
                    Peak_Best=min(Best_vector); %The lower the fitness, the better
                    Fit_var=var(Best_vector);
                    fprintf('Average best , Peak best  and Variance= \t %f , %f ,  %f \n',Av_Best,Peak_Best,Fit_var)
                end
            end
        end
    end
end

Table=table(NIND,ELITIST,PR_CROSS,PR_MUT,LOCALLOOP,NVAR,Av_Best,Peak_Best,Fit_var)



end