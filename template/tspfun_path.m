%
% ObjVal = tspfun(Phen, Dist)
% Implementation of the TSP fitness function
%	Phen contains the phenocode of the matrix coded in path
%	representation
%	Dist is the matrix with precalculated distances between each pair of cities
%	ObjVal is a vector with the fitness values for each candidate tour (=each row of Phen)
%

function ObjVal = tspfun_path(Phen, Dist)
    l = size(Phen,1);
    ObjVal = zeros(l,1);
    max = size(Phen,2);
    for i=1:l
        ObjVal(i)=Dist(Phen(i,1),Phen(i,2));
        for t=2:max-1

            ObjVal(i)=ObjVal(i)+Dist(Phen(i,t),Phen(i,t+1));
        end
        ObjVal(i)=ObjVal(i)+Dist(Phen(i,max),Phen(i,1));
    end
end
% End of function

