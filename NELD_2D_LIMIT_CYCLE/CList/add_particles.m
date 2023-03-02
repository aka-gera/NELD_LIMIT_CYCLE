 
% Construct cell list
function Z = add_particles(X, Z, pbc, param)
      
Z = celn( Z, pbc.L );

    for i = 1:param.nPart
        Z = vec_index(X, Z, pbc.Linv, i) ; 
        Z.list(i) = Z.head(Z.c); 
        Z.head(Z.c) = i;
    end
end

