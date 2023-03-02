% clc;
clear  ;close all;
addpath('CList')
addpath('graph')

rng('default');

flow = 'eld';                     % choose the type of the flow (i.e 'eld', 'shear',  or 'pef') 
nPart = 2    ;                     % Number of particles
epsilon = 1.0;                    % rate of the deformation of the background flow
rcut = 30  ;                      % raduis cut
animation =   11 ;                 % 1 to activate the animation simulation box
N =  500   ;                      % number of step in a period
Nperiod = 15000      ;              % number of period

[pbc, param, list, X, sav]= Parameter(flow,epsilon,nPart,rcut,N,Nperiod);  %  get the parameters

sav = Simulation(X,pbc,param,list,sav,animation);
%
figure(1)
clf
plot( sav.F(:),'.-k')
xlabel('time')
ylabel('Force')
grid on


nTotal = 6;       % Total number of subplot
nRow = 2;         % Number of row       
 

% Plot the density of the simulation box 
tic;
dataGraph(sav,pbc,nRow,nTotal )
tt=toc;
disp(['Time of graph data = ',num2str(tt/60), ' min'])

% Plot the density with some replicas
aj =2.5;

tic;
datF = paramFig(pbc.flow,param.a);
dataGraph2(sav,pbc,nRow,nTotal,aj,datF ,param )
tt=toc;
disp(['Time of graph data = ',num2str(tt/60), ' min'])









