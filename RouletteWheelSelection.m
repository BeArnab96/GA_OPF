function i=RouletteWheelSelection(P)

    r=rand;
    
    cuml=cumsum(P);
    
    i=find(r<=cuml,1,'first');

end