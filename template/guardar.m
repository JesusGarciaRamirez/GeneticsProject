function guardar(s)
    save('Results\ej_guardar.mat','s')
end

Eff_str.index=5;
dataset_file="data.tsp"
[ ~,filename, ~]=fileparts(dataset_file);

name=sprintf("ejguardar%s.mat",filename)
save(name,"Eff_str")


dataset_file='rondrit016.tsp';
[x,y,NVAR]=load_data(dataset_file); %%Getting Dataset (Index) to perform test
run(x,y,NVAR,dataset_file);

1/5