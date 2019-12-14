function plot_timeseries(result_struct_file,NIND_vect)


[ ~,filename, ~]=fileparts(result_struct_file)
strSplit=split(filename,'_');
Dataset_name=char(strSplit(3));

f=figure

hold on
for i = 1:length(NIND_vect)
    NIND=NIND_vect(i);
    [time_values,res_values]=get_timeseries(result_struct_file,NIND);
    ts=timeseries(res_values,time_values);
    ts.Name = 'Fitness';
    ts.TimeInfo.Units = 'epochs';
    plot(ts)

end


%%Plot specs
grid on

if(length(strSplit)>=4)
    par_comb_idx=char(strSplit(4));
    title(sprintf("Fitness update over time Dataset(%s) Parameter Comb (%s)",Dataset_name,par_comb_idx))
else
    title(sprintf("Fitness update over time Dataset(%s) ",Dataset_name))

end

xlabel('Epochs')
ylabel('Fitness')

NIND_legend=int2str(NIND_vect');
legend(NIND_legend,'Location','northeast')

savefig(sprintf("%s",filename))

saveas(f,sprintf("%s.jpg",filename))

close
end
