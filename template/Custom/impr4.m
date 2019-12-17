function [offspring, improve] = impr4(parent,parentl,dist)
    % Performs improvement algorithm 4
    improve = 0;
    max_ratio = 0.2;
    nnodes = length(parent);
    len_max = round(nnodes*max_ratio);
    fir = randi([1,nnodes],1,1);
    len = randi([2,len_max],1,1);
    nodes = zeros(1,len);
    current = fir;
    next = fir + 1;
    if next == nnodes + 1
        next = 1;
    end
    sec = next;
    % Nodesl contains the original length of the nodes chain
    nodesl = 0;
    % Get nodes to rearrange
    for i=1:len
        nodes(i) = parent(next);
        nodesl = nodesl + dist(parent(current),parent(next));
        current = next;
        next = next + 1;
        if next == nnodes + 1
            next = 1;
        end
    end
    ordered_nodes = zeros(1,len);
    current = parent(fir);
    orderedl = 0;
    for i=1:len
        % get possible distances to remaining nodes
        possible_dists = arrayfun(@(x) dist(current,x), nodes);
        [newdist,inodesmin] = min(possible_dists);
        minn = nodes(inodesmin);
        ordered_nodes(i) = minn;
        orderedl = orderedl + newdist;
        % delete node
        nodes(inodesmin) = [];
        current = minn;
    end
    offspring = parent;
    % improvement
    if orderedl < nodesl
        improve = 1;
        current = sec;
        for i=1:len
            offspring(current) = ordered_nodes(i);
            current = current + 1;
            if current == nnodes + 1
                current = 1;
            end
        end
    end
    
end

