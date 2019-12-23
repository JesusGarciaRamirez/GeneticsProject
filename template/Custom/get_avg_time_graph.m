function out = get_avg_time_graph(bests,times,x,tics)
    
    n = size(bests, 2);
    % Re-scaling
    max = x*tics;
    output = NaN(n,max);
    
    for i=1:n
        times{i} = tics*times{i};
        a = 0; 
        m = length(bests{i});
        output(i,1) = bests{i}(1);
        j = 1;
        while j <= m
            if floor(times{i}(j)) > a
                a = a + 1;
                output(i,a+1) = bests{i}(j);
            else
                j = j + 1;
            end
            if a >= max-1
                break;
            end
        end
        output(i, isnan(output(i, :))) = bests{i}(m);
    end
    if n > 1
        out = mean(output);
    else 
        out = output;
    end
end

