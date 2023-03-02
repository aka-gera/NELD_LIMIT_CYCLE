function [pbc, param, Clist, part, sav ]= Parameter(flow,epsilon,nPart,rcut,N,Nperiod)

if nPart < 2
    error("The number of particles is invalide")
end

switch flow
    case 'eld'         % Equilibrium Langevin  flow A=0
        % rescale of the simulation box
        if nPart <=2
            a = 10 ;
        else
            a = 2*nPart ;
        end
        A= [0 0 0;0 0 0;0 0 0];
        invL0 =eye(3)/a ;
        Y = A;
        Yoff = zeros(3);
        Sigma = 1;
        dim = 2;
    case 'shear'         % shear flow case with LE
        % rescale of the simulation box
        if nPart <=2
            a = 10 ;
        else
            a = 2*nPart ;
        end
        A = epsilon*[0 1 0;0 0 0;0 0 0];
        invL0 = eye(3)/a;
        Y = A;
        Yoff = zeros(3);
        Sigma = epsilon;
        dim = 2;
    case 'pef'           % PEF case with KR
        % rescale of the simulation box
        if nPart <=4
            a = 20 ;
        else
            a = 6*nPart ;
        end
        A = epsilon*[-1 0 0;0 1 0;0 0 0];
        M = [2 -1 0;-1 1 0;0  0 1] ;
        [V,~] = eig(M);
        V = V(:,[1 3 2]) ;
        Y = log(diag(V\M*V)) ;
        Yoff = zeros(3);
        invL0 = V/ abs(det(V))^(1/2)/a ;
        Sigma = -epsilon/Y(1) ;
        dim = 2;
end

pbc.flow = flow;
pbc.L0inv = invL0;
pbc.L0 = inv(invL0);
pbc.Linv = pbc.L0inv;
pbc.L =  pbc.L0;
pbc.A = A;
pbc.Y = Y;
pbc.Yoff = Yoff;
pbc.Sigma = Sigma;
pbc.T = 1/abs(Sigma(1));
pbc.theta = 0 ;
pbc.theta1  = 0;
pbc.n = 0;                  % number of rotation
pbc.dt = pbc.T/N ;          % step size
pbc.N = N;                  % number of stepsize in a period
pbc.Nperiod = Nperiod;      % number of period


part.q = zeros(3, nPart)  ;                        % Initial position of the particles
part.qDist = zeros(3,nPart);                       % Difference between particle positions
part.p = zeros(3, nPart);                     % Initial momentum of the particles
part.p(3,1:nPart) =   zeros(1,nPart) ;
part.f = zeros(3,nPart);                          % Initial force of the particles
part.ff = zeros(1);                         % Initial LJ force of the particles
part.G = zeros(3,nPart);                          % Initial


sav.Q1 = zeros(N,Nperiod);                    % store the different in x position coordinate
sav.Q2 = zeros(N,Nperiod);                    % store the different in y position coordinate
sav.F = zeros(N,Nperiod);                     % store the differentiation of the potential


param.sigm = 4;
param.eps = 1;
param.rcut = rcut ;
param.dim = dim;
param.gamma = 0.1;
param.beta = 1;
param.a = a;
param.nPart = nPart;

Clist.Mmax =   ceil(a/param.rcut*nPart) ;
Clist.vol = a^3*nPart ;
Clist.fac = Clist.vol/param.rcut ;
Clist.head = zeros(Clist.Mmax^3,1);
Clist.list = zeros(nPart,1);
Clist.mc = zeros(1,3);
Clist.da = zeros(1,3);
Clist.nL = zeros(1,3);
Clist.c = zeros(1);
Clist.lc = zeros(1,3);
Clist.region = zeros(1,3);
Clist.M = zeros(1,3);
