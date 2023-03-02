
function histmat = hist2(x, y, xedges, yedges)
% University of Debrecen, PET Center/Laszlo Balkay 2006
% email: balkay@pet.dote.hu
if nargin ~= 4
    error ('The four input arguments are required!');
    return;
end
if any(size(x) ~= size(y))
    error ('The size of the two first input vectors should be same!');
    return;
end
[~, xbin] = histc(x,xedges);
[~, ybin] = histc(y,yedges);
xbin(xbin == 0) = inf;
ybin(ybin == 0) = inf;
xnbin = length(xedges);
ynbin = length(yedges);
if xnbin >= ynbin
    xy = ybin*(xnbin) + xbin;
    indexshift =  xnbin;
else
    xy = xbin*(ynbin) + ybin;
    indexshift =  ynbin;
end
%[xyuni, m, n] = unique(xy);
xyuni = unique(xy);
xyuni(end) = [];
hstres = histc(xy,xyuni);
clear xy;
histmat = zeros(ynbin,xnbin);
histmat(xyuni-indexshift) = hstres;
end