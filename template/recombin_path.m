function NewChrom = recombin_path(REC_F, Chrom, RecOpt, Dist);
% Recombines population

% Check parameter consistency
   if nargin < 2, error('Not enough input parameter'); end

   % Identify the population size (Nind)
   [Nind,Nvar] = size(Chrom);

   if nargin < 3, RecOpt = 0.7; end
   if nargin > 2,
      if isempty(RecOpt), RecOpt = 0.7;
      elseif isnan(RecOpt), RecOpt = 0.7;
      elseif length(RecOpt) ~= 1, error('RecOpt must be a scalar');
      elseif (RecOpt < 0 | RecOpt > 1), error('RecOpt must be a scalar in [0, 1]'); end
   end


% Select individuals of one subpopulation and call low level function
    NewChrom = [];
    [rows,cols]=size(Chrom);
   
    maxrows=rows;
    if rem(rows,2)~=0
       maxrows=maxrows-1;
    end

    for row=1:2:maxrows

    % crossover of the two chromosomes
    % results in 2 offsprings
    if rand<RecOpt			% recombine with a given probability
        % we do not let recombination occur with two chromosomes with the
        % same starting point, since most of the operator will gicve the
        % same two offspring
        for i=1:cols
            if Chrom(row,i) ~= Chrom(row+1,i)
                break;
            end
        end
        i = 1;%%%%%%%%%%%%%%%%%%%%
        if i > 1
            c1 = [Chrom(row,i:cols),Chrom(row,1:i-1)];
            c2 = [Chrom(row+1,i:cols),Chrom(row+1,1:i-1)];
        else
            c1 = Chrom(row,:);
            c2 = Chrom(row+1,:);
        end
        if strcmp(REC_F,"cross_sequential_constructive") || strcmp(REC_F,"cross_rand_sequential_constructive") || strcmp(REC_F,"cross_mix")
            o1 = feval(REC_F, [c1;c2], Dist);
            o2 = feval(REC_F, [c2;c1], Dist);
        else
            o1 = feval(REC_F, [c1;c2]);
            o2 = feval(REC_F, [c2;c1]);
        end
        if i > 1
            x = cols - i + 1;
            NewChrom(row,:) = [o1(x+1:cols),o1(1:x)];
            NewChrom(row+1,:) = [o2(x+1:cols),o2(1:x)];
        else
           NewChrom(row,:) = o1;
           NewChrom(row+1,:) = o2;
        end
    else
        NewChrom(row,:)=Chrom(row,:);
        NewChrom(row+1,:)=Chrom(row+1,:);
    end
    end

    if rem(rows,2)~=0
       NewChrom(rows,:)=Chrom(rows,:);
    end
    

   
end

