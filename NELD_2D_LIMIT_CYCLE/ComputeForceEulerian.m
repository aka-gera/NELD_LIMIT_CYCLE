function X = ComputeForceEulerian( X,param,pbc)
mm1 = 1e-16;
mm2 = 1e-16;
X.f(1:param.dim,:) = zeros(param.dim,param.nPart);
for i = 1:(param.nPart-1)
    for j = i+1:param.nPart
        X.qDist = X.q(:,i)-X.q(:,j)  ;
        [X.qDist,~] = Remap_Eulerian_q(X.qDist,pbc);
        normqD = norm(X.qDist) ; 
        ff =  fLJ(normqD, param);     

        X.f(:,i) = X.f(:,i) - ff*X.qDist/normqD;
        X.f(:,j) = X.f(:,j) + ff*X.qDist/normqD;

        fnorm =  norm(X.f(:,i));  
        if fnorm  >1e10 
            error("norm of the force is "+ fnorm  +". The particles are getting close to each other")
        end

        if mm1<abs(ff)
            mm1 = abs(ff);
            mm2 = ff;
        end
    end
end
X.ff = mm2;



