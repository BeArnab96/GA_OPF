function [pop_mod,Best_Sol]= ga(pop,S,WorstCost,mpc)

mpc1=mpc;
ng=length(mpc.gen(:,1))-1;
flag=1;
Costs=[pop.Cost];
empty_individual.Position=[];
empty_individual.Cost=[];

if S.selection_type==1
    beta=8; % Selection Pressure
end

if S.selection_type==2
    TournamentSize=3;   % Tournament Size
end


if S.selection_type==1
        P=exp(-beta*Costs/WorstCost);
        P=P/sum(P);
end
%    pop_pow=pop(:,1:ng) ;
%    pop_volt=pop(:,ng+1:end);
   
   
    % Crossover
    if S.cross_type==1||S.cross_type==2
        popc=repmat(empty_individual,S.n_cross/2,2);
    else
        popc=repmat(empty_individual,S.n_cross/2,1);
    end
    for k=1:S.n_cross/2
        
        % Select Parents Indices
        if S.selection_type==1
            i1=RouletteWheelSelection(P);
            i2=RouletteWheelSelection(P);
        end
        if S.selection_type==2
            i1=TournamentSelection(pop,TournamentSize);
            i2=TournamentSelection(pop,TournamentSize);
        end
        if S.selection_type==3
            i1=randi([1 S.nPop]);
            i2=randi([1 S.nPop]);
        end
        
        if S.selection_type==4
            [i1,i2]=StochasticUniversalSampling(pop);
        end

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
%         v1=pop_volt(i1);
%         v2=pop_volt(i2);
        if p1.Cost > p2.Cost
            temp = p1;
            p1 = p2;
            p2 = temp;
        end
%         if v1.Cost > v2.Cost
%             temp = v1;
%             v1 = v2;
%             v2 = temp;
%         end
        
        % Apply Crossover
        if S.cross_type==1
        [popc(k,1).Position, popc(k,2).Position]=SimpleCrossover(p1.Position,p2.Position,S.Xmin,S.Xmax);
%         [vol_Position1,vol_Position2]=SimpleCrossover(v1.Position,v2.Position,S.XMin(ng+1:end),S.XMax(ng+1:end));
%         popc(k,1).Position=[pow_Position1,vol_Position1];
%         popc(k,2).Position=[pow_Position2, vol_Position2];
        popc(k,1).Cost=CostFunction(popc(k,1).Position,mpc,flag);
        popc(k,2).Cost=CostFunction(popc(k,2).Position,mpc,flag);
     
        elseif S.cross_type==2
        [popc(k,1).Position, popc(k,2).Position]=ArithmeticalCrossover(p1.Position,p2.Position,S.Xmin,S.Xmax);
%         [vol_Position1,vol_Position2]=ArithmeticalCrossover(v1.Position,v2.Position,S.XMin(ng+1:end),S.XMax(ng+1:end));
%         popc(k,1).Position=[pow_Position1,vol_Position1];
%         popc(k,2).Position=[pow_Position2, vol_Position2];
        popc(k,1).Cost=CostFunction(popc(k,1).Position,mpc,flag);
        popc(k,2).Cost=CostFunction(popc(k,2).Position,mpc,flag);
        
        elseif S.cross_type==3
        popc(k,1).Position=BLX_alpha(p1.Position,p2.Position,S.Xmin,S.Xmax);
%         vol_Position1=BLX_alpha(v1.Position,v2.Position,S.XMin(ng+1:end),S.XMax(ng+1:end));
%         popc(k,1).Position=[pow_Position1,vol_Position1];
        popc(k,1).Cost=CostFunction(popc(k,1).Position,mpc,flag);
       
        elseif S.cross_type==4
        popc(k,1).Position=WrightsHeuristic(p1.Position,p2.Position,S.Xmin,S.Xmax);
%         popc(k,1).Position=[pow_Position1,vol_Position1];
        popc(k,1).Cost=CostFunction(popc(k,1).Position,mpc,flag);
            
        elseif S.cross_type==5
         popc(k,1).Position=LinearBGA(p1.Position,p2.Position,S.Xmin,S.Xmax);
%         pow_Position1=LinearBGA(p1.Position,p2.Position,S.XMin(1:ng),S.XMax(1:ng));
%         vol_Position1=LinearBGA(v1.Position,v2.Position,S.XMin(ng+1:end),S.XMax(ng+1:end));
%         popc(k,1).Position=[pow_Position1,vol_Position1];
        popc(k,1).Cost=CostFunction(popc(k,1).Position,mpc,flag);
            
        end
        % Evaluate Offsprings
        
        
    end
    popc=popc(:);
    
    
    % Mutation
    popm=repmat(empty_individual,S.n_mu,1);
    for k=1:S.n_mu
        
        % Select Parent
        i=randi([1 S.nPop]);
        p=pop(i);
        
        % Apply Mutation
        popm(k).Position=Mutate(p.Position,S.mu_rate,S.Xmin,S.Xmax);
        
        % Evaluate Mutant
        popm(k).Cost=CostFunction(popm(k).Position,mpc1,flag);
        
    end
    
    % Create Merged Population
    pop=[pop
         popc
         popm]; %%#ok
     
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    
    % Update Worst Cost
    %WorstCost=pop(end).Cost;
    
    % Truncation
    pop_mod=pop(1:S.nPop);
    %Costs=Costs(1:nPop);
    
    % Store Best Solution Ever Found
    Best_Sol=pop(1);
 
end 
