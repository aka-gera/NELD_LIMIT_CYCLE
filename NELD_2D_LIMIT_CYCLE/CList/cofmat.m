 
function cofA = cofmat(A)
    cofA = zeros(size(A));

    for i = 0:2
        for j = 0:2
            cofA(i+1, j+1) = A(mod(i+1,3)+1, mod(j+1,3)+1)*A(mod(i+2,3)+1, mod(j+2,3)+1);
        end
    end

    % cofA = det(A)*inv(A);
end