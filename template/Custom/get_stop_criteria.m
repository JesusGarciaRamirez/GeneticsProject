
function [Stop] = get_stop_criteria(Population, Fitness, StopCriteria, N,F_OPT,MaxGen)
%This function performs 6 different stop criteria
% Inputs:
% * Population: Population of the current generation.
% * Fitness: Array with the best fitness of each generation. Position
% one has the best fitness of generation 1, and so on.
% * StopCriteria: Can take the values 1, 2, 3 or 4:
% 1 -> Stop if there has been a number of generations
% (proportion of the total number of generations)
% PROP_CASE1*length(Fitness) in which the fitness hasn't
% change.
% 2 -> Stop if there is a smaller (variance/mean) than
% VAR_CASE2 in the last N generations.
% 3 -> Stop if an optimal fitness level F_OPT is reached
% 4 -> Number of generations reaches MaxGen
% 5 -> Population diversity drops under
% POP_DIVERSITY*size(Population,1) [POP_DIV is a percentage]
% 6 -> Average rate of improvement over last N generations
% drops under a given rate IMPROVEMENT_RATE_COEF*Max(fitness)
% * N: Number of generations to check
% Output:
% * Stop: =0 if do not stop, and =1 if do stop


PROP_CASE1 = 0.3; %Allowed number (proportion) of iterations with the same fitness.
VAR_CASE2 = 0.3; %Allowed var/mean -> case 2
% F_OPT = nan; %Fitness optimal value -> case 3
% MaxGen = nan; %Maximum number of generations -> case 4

POP_DIVERSITY = 0.5; %Minimum percentage of different individuals of the population
Stop = 0;
IMPROVEMENT_RATE_COEF = 0.02;
Fitness = Fitness(Fitness~=0);
if length(Fitness) >= N
    %Values to check of the Fitness (Fitness Last N-values)
    FitnessLN= Fitness((length(Fitness)-N+1):length(Fitness));
    switch StopCriteria
        case 1
            N_CASE1 = floor(length(Fitness)*PROP_CASE1);
            %FitnessLN = Fitness to check
            FitnessLN= Fitness((length(Fitness)-N_CASE1+1):length(Fitness));
            lastVal = Fitness(length(Fitness));
            if N_CASE1 > 1
                Stop = 1;
                for i = 1:length(FitnessLN)
                    if FitnessLN(i) ~= lastVal
                    Stop = 0;
                    end
                end
            end
        case 2
            if var(FitnessLN)/mean(FitnessLN) < VAR_CASE2
                Stop = 1;
            
            end
        case 3
            if Fitness(length(Fitness)) <= F_OPT
                Stop = 1;
            end

        % case 4
        %     if length(Fitness) >= MaxGen
        %         Stop = 1;
        %     end
        case 4
            %Check how many different indiviuals are
            C = unique(Population,'rows');
            if length(C) < floor(POP_DIVERSITY*size(Population,1))
                Stop = 1;
            end
        case 5
            if (FitnessLN(1)-FitnessLN(length(FitnessLN))) < FitnessLN(1)*IMPROVEMENT_RATE_COEF
                Stop = 1;
            end
        otherwise
            disp('Allowed values for StopCriteria: 1, 2, 3, 4, 5, 6.');
    end
end
end