function try_crossover()

    dist = [1,2,3,1;4,5,6,7;7,8,9,10;11,12,10,14];
    Parent1 = [1,2,4,3];
    Parent2 = [1,3,4,2];
    Parents = [Parent1;Parent2];    
    cross_sequential_constructive(Parents,dist);
    cross_rand_sequential_constructive(Parents,dist);
    
    Parent1 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    Parent2 = [4, 1, 2, 8, 7, 6, 9, 3, 5];
    Parents = [Parent1;Parent2];
    cross_ERX(Parents)
    cross_OX(Parents);
    mut_RSM(Parent1,0);
    mut_PSM(Parent1,0);
    mut_inverse3(Parent1,0);
    
end