
function p= fLJ(rr, param)
 if rr > param.rcut
     p=0.0;
 else 
    p= 4*param.eps*((12*param.sigm^6)/rr^7 - (12*param.sigm^12)/rr^13);  
 end
end

%     p= 4*param.eps*((12*param.sigm^6)/rr^7 - (12*param.sigm^12)/rr^13);  
