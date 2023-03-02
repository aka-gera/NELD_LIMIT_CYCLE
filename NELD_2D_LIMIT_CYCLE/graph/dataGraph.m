function  dataGraph(sav,pbc,nRow,nTotal )
h = figure(2);
clf

QQ1 = sav.Q1';
QQ2 = sav.Q2'; 
Ndata = 100;
xa = min(min(QQ1));
xb = max(max(QQ1));
ya = min(min(QQ2));
yb = max(max(QQ2));
xedges = linspace( xa, xb, Ndata);
yedges = linspace( ya, yb, Ndata); 

minColorLimit = 0;
maxColorLimit = 0;
showTime   = round( linspace(0,pbc.N-1,nTotal));
gtN = numel(showTime);
histMa=zeros( Ndata, Ndata, gtN); 

for k=1:gtN
    i =  showTime(k) +1; 
    histmat  = hist2(QQ1(:,i),QQ2(:,i), xedges, yedges) ;
    minColorLimit = min([min(min(min(histmat))),minColorLimit]);                   % determine colorbar limits from data
    maxColorLimit =max([max(max(max(histmat))),maxColorLimit]);
    histMa(:,:,i)=histmat';
end
 

nColumn = ceil(numel(showTime)/nRow);
limC=[minColorLimit ,maxColorLimit];
for k=1:numel(showTime)
    sk =  showTime(k) +1;
    subplot(nRow,nColumn,k)
    imagesc(xedges,yedges,histMa(:,:,sk),limC); %colorbar ;
    axis square tight ;
    t = 1e-3*round(1e3*(showTime(k))*pbc.dt) ;
    title(['t = ',num2str(t)], 'FontSize', 12);
    view(2)
end

drawnow;
colormap(jet(256));
colorbar('Position',[0.93 0.168 0.022 0.7]);  %
caxis([minColorLimit, maxColorLimit]);             % set colorbar limits
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
set(get(ha,'XLabel'),'Visible','on')
set(get(ha,'YLabel'),'Visible','on')
xlabel('x_1-x_2','Position',[0.50 .08],'VerticalAlignment','top','HorizontalAlignment','center', 'FontSize', 12);
ylabel('y_1-y_2','Position',[0.02  .5],'VerticalAlignment','top','HorizontalAlignment','center', 'FontSize', 12);


 saveas(h,sprintf('%s_Density_Primary_Box.png',pbc.flow));