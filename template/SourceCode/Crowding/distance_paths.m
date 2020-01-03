function d = distance_paths(p,q)
    d = 0;
    len = length(p);
    for i = 1:len-1
        node = p(i);
        ind = find(q == node);
        if ind == len
            nextq = q(1);
        else
            nextq = q(ind + 1);
        end
        if p(i+1) ~= nextq
            d = d + 1;
        end
    end
    node = p(len);
    ind = find(q == node);
    if ind == len
        nextq = q(1);
    else
        nextq = q(ind + 1);
    end
    if p(1) ~= nextq
        d = d + 1;
    end
end
