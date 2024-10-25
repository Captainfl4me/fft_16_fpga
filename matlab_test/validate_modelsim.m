close all
clear all

f = 5;
fe = 4*f;
t = 0:0.01:15/fe;

x = cos(2*pi*f*t);

for k = 0:8
    t_ech=0:15;
    x_ech = cos(t_ech*k*pi/8.0)*0.99;
    X_fft = abs(fft_16(x_ech));
    X_fft_ref = abs(fft(x_ech, 16));
    X_fft_ref(1:9)

    pause
end