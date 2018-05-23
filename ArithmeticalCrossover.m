function [y1, y2]=ArithmeticalCrossover(x1,x2,VarMin,VarMax)
    
    gamma=0.4;
    nVar=numel(x1);
    ng=floor(nVar/2);
    x1_pow=x1(:,1:ng);
    x1_volt=x1(:,ng+1:end);
    x2_pow=x2(:,1:ng);
    x2_volt=x2(:,ng+1:end);
    
    alpha_pow=unifrnd(-gamma,1+gamma,size(x1_pow));
    alpha_volt=unifrnd(-gamma,1+gamma,size(x1_volt));
    
    y1_pow=alpha_pow.*x1_pow+(1-alpha_pow).*x2_pow;
    y1_volt=alpha_volt.*x1_volt+(1-alpha_volt).*x2_volt;
    y2_pow=alpha_pow.*x2_pow+(1-alpha_pow).*x1_pow;
    y2_volt=alpha_volt.*x2_volt+(1-alpha_volt).*x1_volt;
    
    y1=[y1_pow y1_volt];
    y2=[y2_pow y2_volt];
    
    for i=1:nVar
    if y1(1,i)>VarMax(i)
          y1(1,i)=VarMax(i);
    end
      if y1(1,i)<VarMin(i)
          y1(1,i)=VarMin(i);
      end
      if y2(1,i)>VarMax(i)
          y2(1,i)=VarMax(i);
      end
      if y2(1,i)<VarMin(i)
          y2(1,i)=VarMin(i);
      end
    end

end
