
function groups = get_anova_groups(N_tests,test_parameters)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description
% NIND = [50, 100, 150,200];
% ELITIST = [0 .05 .1 .2];
% PR_CROSS = [.5 .7 .9 1];
% PR_MUT = [0 .05 .1 .2];
% N_tests=256;

%%Loading test_parameters
NIND=test_parameters.NIND;
ELITIST=test_parameters.ELITIST;
PR_CROSS=test_parameters.PR_CROSS;
PR_MUT=test_parameters.PR_MUT;

%%Preallocation
groups=struct;
groups.NIND=zeros(1,N_tests);
groups.ELITIST=zeros(1,N_tests);
groups.PR_CROSS=zeros(1,N_tests);
groups.PR_MUT=zeros(1,N_tests);

cont=0;
%%Getting groups
for i=1:length(NIND)
    for j=1:length(ELITIST)
        for k=1:length(PR_CROSS)
            for l=1:length(PR_MUT)
                cont=cont+1;
                groups.NIND(cont)=NIND(i);
                groups.ELITIST(cont)=ELITIST(j);
                groups.PR_CROSS(cont)=PR_CROSS(k);
                groups.PR_MUT(cont)=PR_MUT(l);
                    
            end
        end
    end
end

end

