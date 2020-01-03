function Offspring = inverse3(Parent,foo)
% Exchanges 3 nodes
    Offspring = Parent;
    l = length(Parent);
    a = randi([1,l],1,1);
    b = randi([1,l-1],1,1);
    c = randi([1,l-2],1,1);
    if b >= a
        b = b + 1;
        if c >= a
            c = c + 1;
        end
        if c >= b
            c = c + 1;
        end
    else
        if c >= b
            c = c + 1;
        end
        if c >= a
            c = c + 1;
        end
    end
    
    aux = Offspring(c);
    Offspring(c) = Offspring(b);
    Offspring(b) = Offspring(a);
    Offspring(a) = aux;
end

