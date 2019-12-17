function Offspring = cross_OX(Parents)
% Performs order crossover

    cols=size(Parents,2);
	Offspring=zeros(1,cols);
        
    Visited=zeros(1,cols);
    
    l1 = randi([1,cols],1,1);
    l2 = l1;
    while l1 == l2
        l2 = randi([1,cols],1,1);
    end
    i = l1;
    % Copy part of parent r
    while i ~= l2
        Offspring(i) = Parents(1,i);
        Visited(Offspring(i)) = 1;
        if i == cols
            i = 1;
        else
            i = i + 1;
        end
    end
    % FIll in the rest
    % i iterates over the other parent and j over the offspring
    j = l2;
    while j ~= l1
        opt = Parents(2,i);
        if Visited(opt)
            if i == cols
                i = 1;
            else
                i = i + 1;
            end
        else
            Offspring(j) = opt;
            Visited(opt) = 1;
            if j == cols
                j = 1;
            else
                j = j + 1;
            end
        end
    end
end

