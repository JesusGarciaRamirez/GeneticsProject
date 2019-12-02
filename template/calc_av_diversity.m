function S = calc_av_diversity(Chrom)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description
[~,n_cities]=size(Chrom);
adj_mat=zeros(n_cities,n_cities); 

for i=1:n_cities
    for j=(i+1):n_cities
        if(adj_mat(i,j)~=1)
            adj_mat(i,j)=get_adj(Chrom,i,j);
        end
        adj_mat(j,i)=adj_mat(i,j);
    end
end

%%Get Av diversity
S=(1/(2*n_cities))*sum(adj_mat,"all");
end

function adj_ij = get_adj(Chrom,m,n)
    %myFun - Description
    %
    % Synget_adj = myFun(input)
    %
    % Long description
    
    adj_ij=0;
    [n_chr,n_cities]=size(Chrom);
    
    for i=1:n_chr
        chromosome=Chrom(i,:);
        for j=1:n_cities
            idx = find(chromosome==m);
            if(idx==1 && (chromosome(n_cities)==n||chromosome(idx+1)==n))
                adj_ij=1;
                break;
            elseif(idx==n_cities && (chromosome(idx-1)==n||chromosome(1)==n))
                adj_ij=1;
                break;
    
            elseif (((idx~=1 && idx~=n_cities)) & (chromosome(idx-1)==n||chromosome(idx+1)==n))                         
                adj_ij=1;
                break;
    
            end
    
        end
    end
    
    end

