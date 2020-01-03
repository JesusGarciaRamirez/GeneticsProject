function [average, numequal] = average_distance_chromosomes(Chrom)
%Computes the average distance of a genotyope

    cont = 0;
    [rows,cols]=size(Chrom);
    numequal = 0;        
    for i=1:rows
        for j=i+1:rows
            d = distance_paths(Chrom(i,:), Chrom(j,:));
            if d == 0
                numequal = numequal + 1;
            else
                cont = cont + d;
            end
        end
    end
    total = (rows - 1)*rows/2;
    average = cont/total; 
end

