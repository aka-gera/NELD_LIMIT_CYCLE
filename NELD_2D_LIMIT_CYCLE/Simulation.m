function sav = Simulation(X,pbc,param,list,sav,animation)


datF = paramFig(pbc.flow,param.a);
%    
X = Initialize(X, param,pbc); 
[X,pbc] = EmEulerian(X,pbc,param,list);

tic
igif=1;
for j= 1  : pbc.Nperiod
fmax=1e-16;
    for i=1:pbc.N
        sav.Q1(i,j) = X.qDist(1) ;
        sav.Q2(i,j) = X.qDist(2) ;
        sav.F(i,j) =  X.ff  ;
        t = 1e-3*round(1e3*(i-1)*pbc.dt);
        if animation ==1 
            igif= MyFigBox(pbc.L,X.q,t,j,datF,param,2,igif);  % plot the box with the interaction particles
        end 
 
        [X,pbc] = EmEulerian(X,pbc,param,list); 
        pbc.theta1  = pbc.theta + pbc.Sigma*pbc.dt;             % update the time
        pbc.theta = pbc.theta1- floor(pbc.theta1) ;
        pbc.n= pbc.n+ pbc.theta-pbc.theta1  ;  
        if abs(fmax)< abs(X.ff)
            fmax = X.ff;
        end
    end
    if mod(j,round(pbc.Nperiod/10))==0
        time = toc ;
        disp(['Period ',num2str(j), ' executed in ', num2str(round(1000*time/60)/1000) , ' min'])
        disp(fmax)
    end
end 




