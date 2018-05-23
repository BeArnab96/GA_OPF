function [i1,i2]=StochasticUniversalSampling(pop)

nPop=numel(pop);
fmean=0;

for i=1:nPop
    fmean=fmean+pop(i).Cost;
end
fmean=fmean/nPop;

s=pop(1).Cost;
delta=rand*fmean;
j=1;
Select=[];
while j<nPop
    if delta<s
        Select=[Select,j];
        delta=delta+s;
    else
        j=j+1;
        s=s+pop(j).Cost;
    end
end
n=numel(Select);

i1=Select(1);
i2=Select(1+floor(n/2));
end
    


