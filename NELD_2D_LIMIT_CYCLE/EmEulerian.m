function [X,pbc] = EmEulerian(X,pbc,param,Z)

 
X.q = X.q + (X.p+pbc.A*X.q)*pbc.dt;                         % update position
 
X = ComputeForceEulerian( X,param,pbc);% compute force
% X  = ComputeForceEulerianCell(X,param,pbc,Z);         % compute force
%                                    % update momentum

X.G(1:param.dim,1:param.nPart) = sqrt(2*pbc.dt*param.gamma/param.beta)*randn(param.dim,param.nPart); 
X.p = X.p + X.f*pbc.dt - param.gamma*X.p*pbc.dt+  X.G;
 
[X.q,pbc]=Remap_Eulerian_q(X.q,pbc);    % remapping of the position

