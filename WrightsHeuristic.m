function y1 = WrightsHeuristic(x1,x2,VarMin,VarMax)
    
    nVar=numel(x1);
    ng=floor(nVar/2);
    x1_pow=x1(:,1:ng);
    x1_volt=x1(:,ng+1:end);
    x2_pow=x2(:,1:ng);
    x2_volt=x2(:,ng+1:end);
    y1=zeros(1,nVar);
    y1_pow=y1(:,1:ng);
    y1_volt=y1(:,ng+1:end);
%     y2=zeros(1,nVar);
%     alpha=0.5;
    for i=1:ng
        y1_pow(1,i)= rand*(x1_pow(1,i)-x2_pow(1,i))+ x1_pow(1,i);
    end
    for i=1:nVar-ng
        y1_volt(1,i)= rand*(x1_volt(1,i)-x2_volt(1,i))+ x1_volt(1,i);
    end
    y1=[y1_pow y1_volt];
    for i=1:nVar
 
%       y1(1,i)= rand*(x1(1,i)-x2(1,i))+ x1(1,i);
%       y2(1,i)= rand*(x1(1,i)-x2(1,i))+ x1(1,i);
      if y1(1,i)>VarMax(i)
          y1(1,i)=VarMax(i);
      end
      if y1(1,i)<VarMin(i)
          y1(1,i)=VarMin(i);
      end
    end
    
    
%     y2=max(y2,VarMin);
%     y2=min(y2,VarMax);

end
