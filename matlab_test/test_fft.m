close all
clear all

f = 5;
fe = 4*f;
t_ech=0:1/fe:15/fe;
t = 0:0.01:15/fe;

x = cos(2*pi*f*t);
x_ech = cos(2*pi*f*t_ech);

figure
hold on
plot(t, x)
plot(t_ech, x_ech, "*")
legend("signal", "echantillon")
xlabel("t")
ylabel("x(t)")

figure
hold on
freq_eq = (0:15)*fe/16;
X_fft = abs(fft_16(x_ech, false));
plot(freq_eq, X_fft)
X_fft_ref = abs(fft(x_ech, 16));
plot(freq_eq, X_fft_ref, "--")
legend("FFT", "FFT ref")
xlabel("f(Hz)")
ylabel("Module de X[v]")