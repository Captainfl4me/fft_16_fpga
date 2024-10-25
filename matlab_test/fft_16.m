function y = fft_16(x, figure_on)
    if length(x) ~= 16
        error("Input Array must be of length 16");
    end
    
    x = x/4;
    a = zeros(1, 16);
    for idx = 1:4
        [a(idx), a(idx+4), a(idx+8), a(idx+12)] = radix_4(x(idx), x(idx+4), x(idx+8), x(idx+12));
    end
    if figure_on == true
        figure; plot(1:16, real(a)); title("a real");
        figure; plot(1:16, imag(a)); title("a img");
    end

    b = zeros(1, 16);
    for idx = 1:4
        for j = 0:3
            b(idx+j*4) = a(idx+j*4) * fft_weight((idx-1)*j, 16);
        end
    end
    if figure_on == true
        figure; plot(1:16, real(b)); title("b real");
        figure; plot(1:16, imag(b)); title("b img");
    end

    y = zeros(1, 16);
    for idx = 1:4
        [y(idx), y(idx+4), y(idx+8), y(idx+12)] = radix_4(b((idx-1)*4+1), b((idx-1)*4+2), b((idx-1)*4+3), b((idx-1)*4+4));
    end
end

function y = fft_weight(k, n)
    y = cos(k*pi/(n/2)) - 1i*sin(k*pi/(n/2));
end