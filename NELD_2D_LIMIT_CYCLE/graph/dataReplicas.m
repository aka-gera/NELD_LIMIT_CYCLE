function qq = dataReplicas(L,q,dat,param) 
% input
        % L : simulation box in 2 dimension
        % q: position of the particles
        % dat : unit Lattice grid
        
%  output 
         % qq : position of the particles in the simulation box and its replicas
         % Lk : simulation box in 3 dimension
         %  LB : simulation box with its replicas
%            
LL =  L*dat.PP'    ;
inds = LL(1,:)<dat.xmax & LL(1,:)>-dat.xmax ...
    & LL(2,:)<dat.ymax & LL(2,:)>-dat.ymax ...
    & LL(3,:)<dat.zmax & LL(3,:)>-dat.zmax;

% inds = LL(1,:)<dat.xmax & LL(1,:)>dat.xmin ...
%    & LL(2,:)<dat.ymax & LL(2,:)>dat.ymin ...
% & LL(3,:)<dat.zmax & LL(3,:)>dat.zmin;
mm = size(q,2);
LB = LL(:,inds) ;
[~,nn] = size(LB);
qq = zeros(3,nn,mm); 
qL = LB(1:3,:);  

for i = 1:mm
    qq(:,:,i)=qL+repmat(q(:,i),1,nn);
end