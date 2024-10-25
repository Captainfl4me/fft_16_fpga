# FFT-16 on FPGA

The goal of this project is to implement a 16 points FFT on FPGA.

# Matlab model

First, the computing model was implemented on MATLAB script to try computing logic. The fft-16 is composed of Radix-4 blocs as follows:

![scheme](./matlab_test/fft_16.drawio.png)

This is the output on a 5Hz cosinus sample at $f_e=20Hz$:

<u>Input signal (temporal):</u>
![ech](./matlab_test/signal_ech_5hz.jpg)

<u>FFT-16 result (frequency domain):</u>
![fft_16](./matlab_test/fft16_5hz.jpg)
