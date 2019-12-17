function Offspring = cross_rand_sequential_constructive(Parents,dist)
% Sequential constructive crossover with rnad choosing using square
% distance

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
                l = length(feasible);
                feasible_distances = zeros(1,l);
                for j=1:l
                    feasible_distances(j) = dist(Offspring(i-1),feasible(j));
                end
                choice = choose(feasible_distances);
                Offspring(i) = feasible(choice);
            else
                Offspring(i) = opt2;
            end
        else
            if unfeasible2
                Offspring(i) = opt1;
            else
                choice = choose([dist(Offspring(i-1),opt1),dist(Offspring(i-1),opt2)]);
                if  choice == 1
                    Offspring(i) = opt1;
                else
                    Offspring(i) = opt2;
                end
            end
        end
        Visited(Offspring(i)) = 1;             
    end          
end

function choice = choose(dist)
    l = length(dist);
    x = zeros(1,l);
    sum = 0;
    x(1) = dist(1)*dist(1);
    for i=2:l
        x(i) = x(i-1) + dist(i)*dist(i);
        sum = sum + x(i);
    end
    r = rand(1,1)*sum;
    choice = 1;
    for i=1:l
        if r < x(i)
            choice = i;
            return
        end
    end
end
    
    