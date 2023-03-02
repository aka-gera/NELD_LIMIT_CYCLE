% Remapping function of the position in the Euerian coordinates (section 2.3.2)


function [q,pbc]=Remap_Eulerian_q(q,pbc)


% pbc.L = expm( pbc.n(1)*pbc.Yoff )*MyExp( pbc.Y*pbc.theta) *pbc.L0;
% pbc.Linv = pbc.L0inv*MyExp( -pbc.Y*pbc.theta) *expm(- pbc.n(1)*pbc.Yoff ) ;
pbc.L =expm(pbc.theta*pbc.A)* pbc.L0;
pbc.Linv = pbc.L0inv*expm(-pbc.theta*pbc.A) ;
% R=L*g(L\q);
% inv(pbc.L) 
q = pbc.L *MyRound(pbc.Linv*q);