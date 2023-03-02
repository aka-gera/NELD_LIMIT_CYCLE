% Clear list
function Z = clear_list(Z,param)
    Z.list = zeros(param.nPart,1);
    Z.head = zeros(Z.Mmax^3,1);
end