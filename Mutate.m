
function y=Mutate(x,mu,VarMin,VarMax)

    nVar=numel(x);
    
    nummu=ceil(mu*nVar);
    
    j=randsample(nVar,nummu);
    
    sigma=0.1*(VarMax-VarMin);
    
    y=x;
    y(j)=(x(j)'+sigma(j).*(randn(size(j))))';
    
    for i=1:nVar
      if y(1,i)>VarMax(i)
          y(1,i)=VarMax(i);
      end
      if y(1,i)<VarMin(i)
          y(1,i)=VarMin(i);
      end
    end

end