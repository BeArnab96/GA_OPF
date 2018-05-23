function [F] = CostFunction(X,mpc,flag)

mpc1=mpc;
% a=mpc1.gencost(:,5);
% b=mpc1.gencost(:,6);
% c=mpc1.gencost(:,7);
Sbase=mpc.baseMVA;
nb=length(mpc.bus(:,1));
ng=length(mpc.gen(:,1))-1;

%% Modification of the MATPOWER case struct with solution vector

mpc1.gen(2:end,2)=X(1:ng);
mpc1.gen(1:end,6)=X(ng+1:end);
% tr=find(mpc.branch(:,9)~=0);
% mpc1.branch(tr,9)=X(2*ng+1:end);


%% POWER FLOW
opt=mpoption('VERBOSE',0,'OUT_ALL',0,'OUT_SYS_SUM',0,'OUT_BUS',0,'OUT_BRANCH',0);

[res]=runpf(mpc1,opt);
pg=res.gen(:,2);
Pgslack=pg(1);
V=res.bus(:,8);
Qgen=res.gen(:,3);

%% Cost Function

lbus=find(mpc1.bus(:,2)==1);
demand=sum(mpc1.bus(lbus,3));
loss= sum(pg)- demand;


%% PENALTY FACTORS
P1=500;
P2=1000;
P3=100;

%% PENALTY FUNCTIONS

%% Penalty function for slack bus power violation

Pgslackmin=mpc1.gen(1,10);
Pgslackmax=mpc1.gen(1,9);

if Pgslack>Pgslackmax
         penalty_slack=P1*(((Pgslack-Pgslackmax)/Sbase)^2);
        
    elseif Pgslack<Pgslackmin
         penalty_slack=P1*(((Pgslackmin-Pgslack)/Sbase)^2);
        
     else
         penalty_slack=0;
end


%% Penalty function for bus voltage violation


Vmax=mpc1.bus(:,12);
Vmin=mpc1.bus(:,13);
   for i=1:nb
     if res.bus(i,2)==1
       if V(i)>Vmax(i)
             penalty_V(i)=P2*(V(i)-Vmax(i))^2;
            
        elseif V(i)<Vmin(i)
             penalty_V(i)=P2*(Vmin(i)-V(i))^2;
            
         else
             penalty_V(i)=0;
       end
    end
   end
    penalty_V=sum(penalty_V);
   
   
%% Penalty function for reactive power generation violation

Qmax=mpc1.gen(:,4);
Qmin=mpc1.gen(:,5);
   for i=1:ng
        if Qgen(i)>Qmax(i)
             penalty_Qgen(i)=P3*(((Qgen(i)-Qmax(i))/Sbase)^2);
              
        elseif Qgen(i)<Qmin(i)
             penalty_Qgen(i)=P3*(((Qmin(i)-Qgen(i))/Sbase)^2);
             
         else
             penalty_Qgen(i)=0;
        end
   end
    penalty_Qgen=sum(penalty_Qgen);
   
   


%% CUMULATIVE PENALTY FUNTION

 penalty=penalty_slack+penalty_V+penalty_Qgen;

%% TOTAL AUGMENTED OBJECTIVE FUNCTION

F = loss  + penalty;

%% Optional Printing of objectives

if flag==1
    res1=runpf(mpc1);
%     fprintf('\n\n****************************************************************\n\n');
%     fprintf('\n Loss = %8.2f $/hr\n\n\n',loss);
end



end

