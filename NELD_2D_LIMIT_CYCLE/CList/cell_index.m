
function c = cell_index(ci1, ci2, ci3, M)
c1 = wrap(ci3, M(3)) ;
c2 = wrap(ci2, M(2))*M(3);
c3 = wrap(ci1, M(1))*M(2)*M(3);
% %     c1 =   ci3 ;
% %     c2 =  ci2 *M(3);
% %     c3 =  ci1 *M(2)*M(3);
c = 1 + c1 + c2 + c3;


% % ci1 = mod(ci1+ M(1), M(1));
% % ci2 = mod(ci2+ M(2), M(2));
% % ci3 = mod(ci3+ M(3), M(3));
% % %
% % %                 ci1 = mod(ci1-1+ M(1), M(1))+1;
% % %                 ci2 = mod(ci2-1+ M(2), M(2))+1;
% % %                 ci3 = mod(ci3-1+ M(3), M(3))+1;
% % c1 =   ci3 ;
% % c2 =  ci2 * M(3);
% % c3 =  ci1 * M(2)* M(3);
% % c = 1 + c1 + c2 + c3 ;
% %
% %
% %