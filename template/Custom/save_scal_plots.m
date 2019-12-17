%%Path navigation
ls_list=dir; %%Use this in the folder where the files are
NIND=[20,50,80,100,120];

for el=1:length(ls_list)
    filename=ls_list(el).name;
    if(contains(filename,"Running_Res"))
        %%Process getting graph
        plot_timeseries(filename,NIND)
        
    end
end

