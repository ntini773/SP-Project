clear;
clc;
E3_data =  load("E3.mat");
E1_data = load("E1.mat");

org_data = E1_data.E1;

given_data = E3_data.E3;
my_data = given_data(1:300);

N = length(my_data);
f = (0:N-1);
wf = (2/N)*f;
fs = 128;

% highpass(my_data,0.2,fs);
% lowpass(my_data,0.02*pi*250,fs);
% figure;
% plot(my_data);
% grid on;

% figure;
% stem(f,abs((fftshift(fft(my_data)))));
% grid on;

% figure;
% stem(wf,abs(fft(my_data)));
% grid on;

[b,a] = butter(20,60/128,"low");

y = filter(b,a,my_data);


subplot(2,1,1);
plot(my_data)
subplot(2,1,2)
plot(y)