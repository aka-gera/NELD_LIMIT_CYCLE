function [X, Z] =ComputeForceEulerianCell(X,param,pbc,Z)

mm1 = 1e-16;
mm2 = 1e-16;

X.f(1:param.dim,:) = zeros(param.dim,param.nPart);
Z = clear_list(Z,param);
Z = add_particles(X, Z, pbc , param);
for i = 1:param.nPart
    Z = vec_index(X, Z,pbc.Linv, i);
    % Go through adjacent cells
    for mcl_1 = Z.mc(1)-1 : Z.mc(1)+1
        for mcl_2 = Z.mc(2)-1 : Z.mc(2)+1
            for mcl_3 = Z.mc(3)-1 : Z.mc(3)+1
                Z.c = cell_index(mcl_1, mcl_2, mcl_3, Z.M) ;

                % Apply periodic boundary conditions


                j = Z.head(Z.c) ;
                while j ~= 0
                    if j>i
                        X.qDist = X.q(:,i)-X.q(:,j)  ;
                        [X.qDist,~] = Remap_Eulerian_q(X.qDist,pbc);
                        normqD = norm(X.qDist) ;
                        ff =  fLJ(normqD, param)  ;
                        X.f(:,i) = X.f(:,i) - ff*X.qDist/normqD;
                        X.f(:,j) = X.f(:,j) + ff*X.qDist/normqD;

                        fnorm =  norm(X.f(:,i));
                        if fnorm  >1e10
                            error("norm of the force is "+ fnorm  +". The particles are getting close to each other")
                        end

                        if mm1<abs(ff)
                            mm1 = abs(ff);
                            mm2 = ff;
                        end
                    end
                    j = Z.list(j) ;
                end
            end
        end
    end
end

X.ff = mm2;