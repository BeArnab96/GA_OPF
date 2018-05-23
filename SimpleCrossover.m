function [y1, y2]=SimpleCrossover(x1,x2,VarMin,VarMax)
    
    nVar=numel(x1);
    ng=floor(nVar/2);
    x1_pow=x1(:,1:ng);
    x2_pow=x2(:,1:ng);
    
    poc1=randsample(ng-1,1);
    
    y1_pow=[x1_pow(1:poc1),x2_pow(poc1+1:end)];
    y2_pow=[x2_pow(1:poc1),x1_pow(poc1+1:end)];
    
    x1_volt=x1(:,ng+1:end);
    x2_volt=x2(:,ng+1:end);
    poc2=randsample((nVar-ng)-1,1);
    
    y1_volt=[x1_volt(1:poc2),x2_volt(poc2+1:end)];
    y2_volt=[x2_volt(1:poc2),x1_volt(poc2+1:end)];
    
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
