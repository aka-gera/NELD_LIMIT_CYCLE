function X = Initialize(X, param,pbc)
if param.dim == 3
    ll = 1;
    for l  = 1:param.nPart
        i = l+1;
        j = i+1;
        X.q(3,ll) = (0.5 + i-0.5*param.nPart)/param.nPart;
        X.q(2,ll) = (0.5 + j-0.5*param.nPart)/param.nPart;
        X.q(1,ll) = (0.5 + l-0.5*param.nPart)/param.nPart;
        ll = ll + 1;
    end
else
    ll = 1;
    for l = 1:param.nPart
        j = l+1;
        X.q(3,ll) = 0;
        X.q(2,ll) = (0.5 + j-0.5*param.nPart)/param.nPart;
        X.q(1,ll) = (0.5 + l-0.5*param.nPart)/param.nPart;
        ll = ll + 1;
    end
end
X.q = pbc.L * X.q ;
X.q(1:param.dim,:) = X.q(1:param.dim,:) + 0.05 * randn(param.dim, param.nPart);
X.p = pbc.A * X.q;
X.p(1:param.dim,:) = X.p(1:param.dim,:) + sqrt(1/param.beta) * randn(param.dim, param.nPart);
end
