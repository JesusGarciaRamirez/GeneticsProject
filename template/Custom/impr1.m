function [offspring, improve] = impr1(parent,parentl,dist)
    % Performs improvement algorithm 1
    improve = 0;
    nnodes = length(parent);
    i = 0;
    % r is the index of the arc selected
    r = randi([1,nnodes],1,1);
    while i ~= nnodes
        % Check distance of r to the other nodes
        
        if r==nnodes
            next = 1;
        elseif r==nnodes + 1
            r = 1;
            next = 2;
        else
            next = r + 1;
        end
        node = parent(r);
        mind = dist(node,parent(next));
        % minn is the index of the new connection
        minn = next;
        for j = 1:nnodes
            
            if r~=j
                if dist(node,parent(j)) < mind
                    mind = dist(node,parent(j));
                    minn = j;
                end
            end
        end
        % If we found a possible better edge
        if minn ~= next
            if minn == nnodes
                minnext = 1;
                minnant = minn - 1;
            elseif minn == 1
                minnext = minn + 1;
                minnant = nnodes;
            else
                minnext = minn + 1;
                minnant = minn - 1;
            end
            newl = parentl + dist(parent(r),parent(minn)) + dist(parent(minn),parent(next))...
                + dist(parent(minnant), parent(minnext)) - dist(parent(r), parent(next))...
                - dist(parent(minnant),parent(minn)) - dist(parent(minn),parent(minnext));
            if newl < parentl
                offspring = parent;
                if r < minn
                    offspring(r + 1) = parent(minn);
                    for k = r+2:minn
                        offspring(k) = parent(k-1);
                    end
                else
                    for k = minn:r-1
                        offspring(k) = parent(k+1);
                    end
                    offspring(r) = parent(minn);
                end
                improve = 1;
                return;
            end
        end
        r = r + 1;
        i = i + 1;
        
    end
    offspring = parent;   
end

