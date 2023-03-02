
    function singleFill(PP,dat)
        
lw = dat.MainBoxMarkerWidth;
bOpaque = dat.MainBoxOpaque;
bEdge = dat.MainBoxEdge;
bColor = dat.Color;
%         bColor = PP(3,:);
        fill3(PP(1,:), PP(2,:),PP(3,:),bColor,...
            'FaceAlpha',bOpaque,...
            'LineStyle',bEdge,'LineWidth',lw)%,...
        %    'FaceColor', 'texturemap')%R
    end