function f =MyExp(M)
[mm,nn] = size(M);
if mm == nn
    f = expm(M);
else
    f = diag(exp(M));
end