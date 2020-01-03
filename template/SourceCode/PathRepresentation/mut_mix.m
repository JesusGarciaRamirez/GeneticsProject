function Offspring = mut_mix(Parent,foo)
% Select randomly a mutation operator
    r = randi([1,3],1,1);
    if r==1
        Offspring = mut_inverse3(Parent);
    elseif r==2
        Offspring = mut_PSM(Parent);
    else
        Offspring = mut_RSM(Parent);
    end
end  


