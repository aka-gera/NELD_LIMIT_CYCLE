function   igif= MyFigBox(L,q,t,j,datF,param,pauseSwitch,igif)
% input
% L: Lattice in 2d
% q : position of the particles
%  f : interparticles force
% ij: gif shift
% t : time
% poz : 1 to pause the display

filename = 'KR.gif';
del=.1;
qq = dataReplicas(L,q,datF,param) ;

figg=gca;
hold on 
set(figg, 'Visible', 'on'); 

p1=L(:,1);p2=L(:,2);p3=L(:,3);p0=[0 0 0]';

p4=p1+p2;
p5=p1+p3;
p6=p2+p3;
p7=p3+p4;

singleFill([p0,p1,p4,p2],datF)
singleFill([p0,p1,p5,p3],datF)
singleFill([p0,p2,p6,p3],datF)
singleFill([p7,p5,p3,p6],datF)
singleFill([p1,p5,p7,p4],datF)
singleFill([p4,p7,p6,p2],datF)

axis(datF.Axi)
figg = gca;
set(figg, 'Visible', 'off');

% MyGridPoints(L,datF)                % grid points

%  icolor =[(1-linspace(0,1,param.nPart))',ones(param.nPart,1),zeros(param.nPart,1)]

 icolor =[(log(linspace(1,exp(1),param.nPart)))',log(linspace(1,exp(1),param.nPart))',zeros(param.nPart,1) ];

% icolor=[1 0 0 
%     1 0 1
%     0 1 0
%     0 0 1
%     1 1 0
%     ];      % color
[~,nn,~]=size(qq);
I1=ones(1,nn);
for ic=1:param.nPart
    scatter3(qq(1,:,ic),qq( 2,:,ic),I1,'filled',...
        'MarkerEdgeColor',icolor(ic,:),...
        'Marker','o',...
        'LineWidth',3)
 end
 
title(['time = ',num2str(t), ',  period num = ',num2str(j)])
xlabel('x')
ylabel('y')
zlabel('z')
view(0,90)
hold off
drawnow;
frame = getframe(1);%getframe(figg);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);

if igif == 1
    imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',del);
else
    imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',del);
end
if pauseSwitch==1
    pause;
end
% saveas(gcf,['pbc_',num2str(igif)],'png');
igif=igif+1;
delete(figg);