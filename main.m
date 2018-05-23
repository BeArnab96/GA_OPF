clc;
clear;
close all;

mpc=loadcase('case30');
data=mpc;
ng=length(mpc.gen(:,1))-1;
flag=1;
Vg=mpc.gen(1:end,6);
S.nVar=2*ng + 1;                         % Number of Dimensions
% VarSize=[1 S.nVar];                
% VarSize_P=[1 ng];
% VarSize_V=[1 ng+1];
Pgmin=data.gen(2:end,10);
Pgmax=data.gen(2:end,9);
Vgmin=ones(length(Vg),1)*0.94;
Vgmax=ones(length(Vg),1)*1.06;
S.Xmin=[Pgmin;Vgmin];
S.Xmax=[Pgmax;Vgmax];
%% GA Parameters

S.MaxIt=200;     
S.nPop=30;       

S.p_cross=0.8;                 % Crossover Percentage
S.n_cross=2*round(S.p_cross*S.nPop/2);  % Number of Offsprings (also Parents)
%gamma=0.4;              % Extra Range Factor for Crossover

S.p_mu=0.3;                 % Mutation Percentage
S.n_mu=round(S.p_mu*S.nPop);      % Number of Mutants
S.mu_rate=0.1;                 % Mutation Rate

S.selection_type=input('What selection method you want to employ: 1. Roulette Wheel Selection  2. Tournament Selection  3. Random Selection  4. Stochastic Universal Sampling?  ');

S.cross_type=input('What crossover type do you want : 1. Simple crossover  2.Arithmetical Crossover  3.BLX-alpha  4. Wrights Heuristic  5. Linear BGA ?  ');




% pause(0.01); % Due to a bug in older versions of MATLAB

%% Initialization


empty_individual.Position=[];
empty_individual.Cost=[];

pop=repmat(empty_individual,S.nPop,1);

for i=1:S.nPop
    for k=1:S.nVar
    % Initialize Position
    pop(i).Position(k)= S.Xmin(k)+rand*(S.Xmax(k)-S.Xmin(k));
    end
    % Evaluation
    pop(i).Cost=CostFunction(pop(i).Position,data,flag);
    
end

% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);

% Store Best Solution
BestSol=pop(1);

% Array to Hold Best Cost Values
BestCost=zeros(S.MaxIt,1);

% Store Cost
WorstCost=pop(end).Cost;
tic;
for it=1:S.MaxIt
    [pop_mod,Best_Sol]=ga(pop,S,WorstCost,mpc);
    pop=pop_mod;
    WorstCost=max(WorstCost,pop(end).Cost);
    BestCost(it)=Best_Sol.Cost;
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
end
z=toc;
disp('Time elapsed in the optimiation is');
disp(z);
disp(['Best Solution is :']);
disp(Best_Sol);
figure;
semilogy(BestCost,'LineWidth',2);
% plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Cost');
grid on;