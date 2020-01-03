function [offspring, improve] = impr3(parent,parentl,dist)
    % Performs improvement algorithm 3
    nnodes = length(parent);
    i = 0;
    improve = 0;
    % fir is the index of the first node in the chain
    fir = randi([1,nnodes],1,1);
    while i ~= nnodes        
        if fir==nnodes
            sec = 1;
        elseif fir == nnodes + 1
            fir = 1;
            sec = 2;
        else
            sec = fir + 1;
        end
        thi = randi([1,nnodes-2],1,1);
        if thi >= fir
            thi = thi + 2;
        end
        if thi==nnodes
            fou = 1;
        else
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
            p = thi - 1;
            o = sec + 1;
            if p == 0
                p = nnodes;
            end
            while p ~= sec
                if o == nnodes + 1
                    o = 1;
                end
                offspring(o) = parent(p);
                o = o + 1;
                p = p - 1;
                if p == 0
                    p = nnodes;
                end
            end
            offspring(thi) = parent(sec);
            improve = 1;
            return
        end
        fir = fir + 1;
        i = i + 1;
        
    end
    offspring = parent;   
end

