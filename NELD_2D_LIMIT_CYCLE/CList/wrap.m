function x = wrap(x, n)
    while x >= n
        x = x - n;
    end
    while x < 0
        x = x + n;
    end
     
end
