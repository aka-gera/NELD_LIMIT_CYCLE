function Z = vec_index(X, Z, Linv, i)
 
    Z.da =   Linv*X.q(:, i) + 0.5*ones(3, 1) ;
    Z.mc = floor(Z.da .* Z.M);
    for k = 1:3
  %       Z.mc(k) = mod(Z.mc(k)+Z.M(k), Z.M(k))  ;
          Z.mc(k) = mod(Z.mc(k), Z.M(k)) ;

    end

    for j = 1:3
        if (Z.mc(j) < 0) || (Z.mc(j) > Z.M(j))
            error("Bad index for particle " + i + "\nCell mc[" + j + "] = " + Z.mc(j))
        end
    end
    Z.c = cell_index(Z.mc(1), Z.mc(2), Z.mc(3), Z.M);
    if Z.c > Z.Mmax^3  
        error("Nonexistence cell index " + Z.c+ " Number of total cell index " + Z.Mmax^3);
    end
end
