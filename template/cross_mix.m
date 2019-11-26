function Offspring = cross_mix(Parents,dist)
% Select randomly a cross operator
    r = randi([1,4],1,1);
    if r==1
        Offspring = cross_ERX(Parents);
    elseif r==2
        Offspring = cross_OX(Parents);
    elseif r==3
        Offspring = cross_rand_sequential_constructive(Parents,dist);
    else
        Offspring = cross_sequential_constructive(Parents,dist);
    end
end  
