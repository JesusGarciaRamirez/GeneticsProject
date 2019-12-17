function Offspring = mut_RSM(Parent,foo)
% Performs Reverse sequence mutation
    cols=length(Parent);
	Offspring=Parent;
    
    l1 = randi([1,cols],1,1);
    l2 = l1;
    while l1 == l2
        l2 = randi([1,cols],1,1);
    end
    i = l1;
    j = l2;
    % i iterates forward and j backwards
    while i ~= l2
        Offspring(i) = Parent(j);
        if i == cols
            i = 1;
        else
            i = i + 1;
        end
        if j == 1
            j = cols;
        else 
            j = j - 1;
        end
    end
    Offspring(i) = Parent(j);
end

