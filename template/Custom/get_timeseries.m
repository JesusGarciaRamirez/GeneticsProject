
function [time_vector,y_vector] = get_timeseries(result_struct,NIND)
  
    load_res=load(result_struct);
    running_res=struct2cell(load_res);
    running_res=running_res{1};

    %%Getting index
    idx=find(running_res.NIND==NIND);
    y_vector=load_res.running_res.best{idx};
    time_vector=(1:1:length(y_vector)); 

    
    % plot(time_vector,y_vector)
        
end

