function [NewChrom,Fit] = crowding(parents, offspring, fitp, fito)
% Performs seterministic crowding to choose who reigns
    NewChrom = [];
    Fit = [];
    [rows,cols]=size(parents);
   
    maxrows=rows;
    if rem(rows,2)~=0
       maxrows=maxrows-1;
    end
    
    for row=1:2:maxrows
       p1 = parents(row, :);
       p2 = parents(row+1, :);
       o1 = offspring(row, :);
       o2 = offspring(row+1, :);
       if distance_paths(o1,p1) + distance_paths(o2,p2) < distance_paths(o1,p2) + distance_paths(o2,p1)
            
           if fitp(row) < fito(row)
               NewChrom(row,:) = p1;
               Fit(row,:) = fitp(row);
           else
               NewChrom(row,:) = o1;
               Fit(row,:) = fito(row);
           end
           if fitp(row+1) < fito(row+1)
               NewChrom(row+1,:) = p2;
               Fit(row+1,:) = fitp(row+1);
           else
               NewChrom(row+1,:) = o2;
               Fit(row+1,:) = fito(row+1);
           end
       else
           if fitp(row) < fito(row+1)
               NewChrom(row,:) = p1;
               Fit(row,:) = fitp(row);
           else
               NewChrom(row,:) = o2;
               Fit(row,:) = fito(row+1);
           end
           if fitp(row+1) < fito(row)
               NewChrom(row+1,:) = p2;
               Fit(row+1,:) = fitp(row+1);
           else
               NewChrom(row+1,:) = o1;
               Fit(row+1,:) = fito(row);
           end
       end
    end
    if rem(rows,2)~=0
       NewChrom(rows,:)=offspring(rows,:);
       Fit(rows,:) = fito(rows);
    end
end


