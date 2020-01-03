function benchmark_list = get_benchmark_files()
    
    cd("TSPBenchmark")  
    ls_list=dir;
    cont=0;
    for i=1:length(ls_list)
        filename=ls_list(i).name;
        if(contains(filename,"tsp"))
            cont=cont+1;
            benchmark_list(cont).name=filename;
        end
    end
    cd ..  %%Get back to base dir

end