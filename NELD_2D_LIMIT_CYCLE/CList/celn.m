
function Z = celn( Z, L )
    cL = cofmat(L);

    for i = 1:3
        Z.nL(i) = Z.fac / norm(cL(:, i));
      Z.M(i) = floor(max(min(Z.nL(i), Z.Mmax),1));

  %         Z.M(i) = floor(min(Z.nL(i), Z.Mmax));
        if (Z.M(i) < 3) || (Z.M(i) > Z.Mmax)
            error("Less than 3 boxes in direction " + i + ", cell list invalid.");
        end
    end
end