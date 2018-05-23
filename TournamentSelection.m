function i=TournamentSelection(pop,m)

    nPop=numel(pop);

    Sample=randsample(nPop,m);
    
    pop_pool=pop(Sample);
    
    new_costs=[pop_pool.Cost];
    
    [~, j]=min(new_costs);
    
    i=Sample(j);

end