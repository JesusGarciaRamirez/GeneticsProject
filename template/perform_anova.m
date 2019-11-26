function stats=perform_anova(table_file,column,test_parameters,N_tests)
    % Long description
    %% Y= Performance metric under analysis, (eg. MBF)
    %%Groups ="set of parameters that can affect the metric variable under analysis(eg. NIND)"

    % test_parameters.NIND = [50, 100, 150,200];
    % test_parameters.ELITIST = [0 .05 .1 .2];
    % test_parameters.PR_CROSS = [.5 .7 .9 1];
    % test_parameters.PR_MUT = [0 .05 .1 .2];
    % N_tests=256;

    groups=struct2cell(get_anova_groups(N_tests,test_parameters));

    %%Read the normalised table and extract the parameter to perform anova
    table_path= ['Results/' table_file];
    assert(isfile(table_path),"Wrong table path");
    T=readtable(table_path);
    
    %%Perform n-way ANOVA to Eff_unit
    if(column=="Eff_unit")
        fprintf("Performing ANOVA of %s",column)
        y=T.Eff_1_unit;
        [~,~,stats] = anovan(y,groups,'model','interaction',...
        'varnames',{'NIND','ELITIST','PR_MUT','PR_CROSS'});

    elseif column=="Av_Best_unit"
        fprintf("Performing ANOVA of %s",column)
        y=T.Av_Best_unit;
        %%Perform n-way ANOVA to Av_Best_unit
        [~,~,stats] = anovan(y,groups,'model','interaction',...
        'varnames',{'NIND','ELITIST','PR_MUT','PR_CROSS'});
    else
        fprintf("Wrong parameter")
    end
    % %%Plotting comparisons
    % results = multcompare(stats,'Dimension',[1 2])



end