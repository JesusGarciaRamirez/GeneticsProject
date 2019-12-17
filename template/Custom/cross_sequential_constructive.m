function Offspring = cross_sequential_constructive(Parents, dist)
% Sequential constructive crossover
% Produces two children

	cols=size(Parents,2);
	Offspring=zeros(1,cols);
    
    Offspring(1) = Parents(1,1);
    Visited=zeros(1,cols);
    Visited(Offspring(1)) = 1;
    
    for i=2:cols
        opt1 = Parents(1,i);
        opt2 = Parents(2,i);
        unfeasible1 = Visited(opt1);
        unfeasible2 = Visited(opt2);
        if unfeasible1
            if unfeasible2
                feasible = find(~Visited);
                minind = feasible(1);
                minval = dist(Offspring(i-1),feasible(1));
                if length(feasible) >= 1
                    for j=2:length(feasible)
                        if dist(Offspring(i-1),feasible(j)) < minval
                            minval = dist(Offspring(i-1),feasible(j));
                            minind = feasible(j);
                        end
                    end
                end
                Offspring(i) = minind;
            else
                Offspring(i) = opt2;
            end
        else
            if unfeasible2
                Offspring(i) = opt1;
            else
                if dist(Offspring(i-1),opt1) <= dist(Offspring(i-1),opt2)
                    Offspring(i) = opt1;
                else
                    Offspring(i) = opt2;
                end
            end
        end
        Visited(Offspring(i)) = 1;             
    end          
end

