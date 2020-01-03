function Result = select_mix(Chrom)
% Mixes chromosomes to select recombination pairs
    r = randperm(size(Chrom,1));
    Result = Chrom(r,:);
end

