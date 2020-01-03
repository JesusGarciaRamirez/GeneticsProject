function [offspring, improve] = impr2(parent,parentl,dist)
    % Performs improvement algorithm 2
    nnodes = length(parent);
    i = 0;
    improve = 0;
    % fir is the index of the first node in the 4 chain
    fir = randi([1,nnodes],1,1);
    while i ~= nnodes        
        if fir==nnodes
            sec = 1;
            thi = 2;
            fou = 3;
        elseif fir==nnodes + 1
            fir = 1;
            sec = 2;
            thi = 3;
            fou = 4;
        elseif fir == nnodes - 1
            sec = nnodes;
            thi = 1;
            fou = 2;
        elseif fir == nnodes - 2
            sec = nnodes - 1;
            thi = nnodes;
            fou = 1;
        else
            sec = fir + 1;
            thi = sec + 1;
            fou = thi + 1;
        end
        a = parent(fir);
        b = parent(sec);
        c = parent(thi);
        d = parent(fou);
        offsl = parentl - dist(a,b) - dist(c,d) + dist(a,c) + dist(b,d);
        if offsl < parentl
            offspring = parent;
            offspring(sec) = parent(thi);
            offspring(thi) = parent(sec);
            improve = 1;
            return
        end
        fir = fir + 1;
        i = i + 1;
        
    end
    offspring = parent;   
end

