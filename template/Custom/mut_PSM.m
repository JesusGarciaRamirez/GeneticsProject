function Offspring = mut_PSM(Parent,foo)
% Performs Partial Shuffle mutation
    l = length(Parent);
    Offspring = Parent;
    prob = 1.0/l;
    for i = 1:l
        if rand() < prob
            r = randi([1,l-1],1,1);
            if r >= i
                r = r + 1;
            end
            aux = Offspring(i);
            Offspring(i) = Offspring(r);
            Offspring(r) = aux;
        end
    end
end

