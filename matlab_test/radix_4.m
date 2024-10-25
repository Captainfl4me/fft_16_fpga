function [y0, y1, y2, y3] = radix_4(x0, x1, x2, x3)
    [a0, a2] = radix_2(x0, x2);
    [a1, a3] = radix_2(x1, x3);

    [y0, y2] = radix_2(a0, a1);
    [y3, y1] = radix_2(a2, 1i*a3);
end