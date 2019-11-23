function Offspring = cross_ERX(Parents)
% ERX crossover
% Select random start node.
% From its feasible neighbours (at most 4) select the one with less neighbours in
% both parents

    cols=size(Parents,2);
	Offspring=zeros(1,cols);
    
    Offspring(1) = Parents(1,1);
    
    Visited=zeros(1,cols);
    Visited(Offspring(1)) = 1;
    
    for i=2:cols
        opts = neighbours(Offspring(i-1),Parents);
        feasible = find(~Visited);
        opts = intersect(opts,feasible);
        if isempty(opts)
            opts = feasible;
        end
        l = length(opts);
        nn = zeros(1,l);
        % check number of neighbours of each option
        for j=1:l
            nn(j) = length(neighbours(opts(j),Parents));
        end
        inds = find(nn == min(nn));
        r = randi([1,length(inds)],1,1);
        Offspring(i) = opts(inds(r));
        Visited(Offspring(i)) = 1;
    end
end

function ns = neighbours(node, Parents)
    ind1 = find(Parents(1,:) == node);
    ind2 = find(Parents(2,:) == node);
    cols=size(Parents,2);
    if ind1 == 1
        a = cols;
        b = 2;
    elseif ind1 == cols
        a = 1;
        b = cols - 1;
    else 
        a = ind1 - 1;
        b = ind1 + 1;
    end
    
    if ind2 == 1
        c = cols;
        d = 2;
    elseif ind2 == cols
        c = 1;
        d = cols - 1;
    else 
        c = ind2 - 1;
        d = ind2 + 1;
    end
    ns = unique([Parents(1,a),Parents(1,b),Parents(2,c),Parents(2,d)]);
end  
