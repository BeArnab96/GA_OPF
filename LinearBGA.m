function y1=LinearBGA(x1,x2,VarMin,VarMax)
    
    nVar=numel(x1);
%     y1=zeros(1,nVar);
    ng=floor(nVar/2);
    x1_pow=x1(:,1:ng);
    x1_volt=x1(:,ng+1:end);
    x2_pow=x2(:,1:ng);
    x2_volt=x2(:,ng+1:end);
%     y1=zeros(1,nVar);
    y1_pow=zeros(1,ng);
    y1_volt=zeros(1,nVar-ng);
    
   range=0.5*(VarMax-VarMin);
    for i=1:ng
    
    gamma1=sum(rand(1,16).*(0.5.^(0:15)));

    lambda_pow=(x1_pow(1,i)-x2_pow(1,i))./norm(x1_pow-x2_pow);
    
    if rand<0.9
        y1_pow(1,i)= x1_pow(1,i)-range(i)*lambda_pow*gamma1;

    else
        y1_pow(1,i)= x1_pow(1,i)+range(i)*lambda_pow*gamma1;

      
    end
    end
    for i=1:nVar-ng
    
    gamma1=sum(rand(1,16).*(0.5.^(0:15)));

    lambda_volt=(x1_volt(1,i)-x2_volt(1,i))./norm(x1_volt-x2_volt);
    
    if rand<0.9
        y1_volt(1,i)= x1_volt(1,i)-range(i)*lambda_volt*gamma1;

    else
        y1_volt(1,i)= x1_volt(1,i)+range(i)*lambda_volt*gamma1;

      
    end
    end
    y1=[y1_pow y1_volt];
    
    for i=1:nVar
      if y1(1,i)>VarMax(i)
          y1(1,i)=VarMax(i);
      end
      if y1(1,i)<VarMin(i)
          y1(1,i)=VarMin(i);
      end
    end
    

end
