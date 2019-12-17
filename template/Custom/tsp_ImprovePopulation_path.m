% tsp_ImprovePopulation.m
% Author: Mike Matton
% 
% This function improves a tsp population by removing local loops from
% each individual.
%
% Syntax: improvedPopulation = tsp_ImprovePopulation(popsize, ncities, pop, improve, dists)
%
% Input parameters:
%   popsize           - The population size
%   distances         - the length of the tours
%   pop               - the current population (adjacency representation)
%   improve           - Improve the population (0 = no improvement, else
%   name of the function to improve)
%   dists             - distance matrix with distances between the cities
%
% Output parameter:
%   improvedPopulation  - the new population after loop removal (if improve
%                          <> 0, else the unchanged population).

function [newpop, improvements] = tsp_ImprovePopulation_path(popsize, distances, pop, improve,dists)
improvements = 0;
if ~strcmp(improve,"")
   for i=1:popsize
     [result,imp] = feval(improve,pop(i,:),distances(i),dists);
     improvements = improvements + imp;
     pop(i,:) = result;
  
   end
end

newpop = pop;