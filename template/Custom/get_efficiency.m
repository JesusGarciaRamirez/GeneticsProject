function [Eff_1,Eff_2]= get_efficiency(test_run,NIND)
%myFun - Description
%
% Syntax: output = myFun(input)
%   Eff=Efficiency metric 
% Long description

%%Transform fitness into maximization fitness (each fitness f_i is trasnformed into 1/(f_i))
test_run_transf=1./test_run;
Eff_1=zeros(1,length(test_run));
Eff_2=zeros(1,length(test_run));

timesteps=length(test_run);

for t = 1:timesteps
    sub_run=test_run_transf(1:t);
    mean_fitness=mean(sub_run);
    weight_factor=(t*NIND)^-1; %% 1/#fitness_evaluations
    current_best=max(sub_run);
    Eff_1(t)=weight_factor*current_best;
    Eff_2(t)=weight_factor*(current_best-mean_fitness);

end

    
end
