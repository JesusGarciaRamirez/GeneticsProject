function compare_timeseries(dirs_info,Dataset_name,NIND)


f=figure

hold on

%%Me muevo en los dirs
for i=1:length(dirs_info)
    cd(dirs_info(i).dir) %%Move to the folder where the results are
    %%Path navigation
    ls_list=dir; %%Use this in the folder where the files are
    for el=1:length(ls_list)
        filename=ls_list(el).name;
        base_name=sprintf("Running_Res_%s",Dataset_name);
    
        if(contains(filename,base_name) && contains(filename,dirs_info(i).dir))   %%If Dataset_name in File
            %%Create stuct array
            [time_values,res_values]=get_timeseries(filename,NIND);
            ts=timeseries(res_values,time_values);
            ts.Name = 'Fitness';
            ts.TimeInfo.Units = 'epochs';
            plot(ts)
   
            
        end
    end
    cd ..  %%Get back to base dir
end
 

%%Plot specs
grid on

title(sprintf("Comparison fitness evolution Dataset(%s) , NIND = %d ",Dataset_name,NIND))

xlabel('Epochs')
ylabel('Fitness')

legend(dirs_info.test_name,'Location','northeast')

fig_path=sprintf("Comparison/%s",base_name);
savefig(sprintf("%s",fig_path))
saveas(f,sprintf("%s.jpg",fig_path))
close
end


