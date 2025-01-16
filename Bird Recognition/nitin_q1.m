clear;
clc

[b1,fs_b1] = audioread("Reference\bird1.wav");
[b2,fs_b2] = audioread("Reference\bird2.wav");
[b3,fs_b3] = audioread("Reference\bird3.wav");

Lb1 = length(b1);
Lb2 = length(b2);
Lb3 = length(b3);

fft_b1 = fftshift(fft(b1));
fft_b2 = fftshift(fft(b2));
fft_b3 = fftshift(fft(b3));

[f1,fs_f1] = audioread("Task\F1.wav");
[f2,fs_f2] = audioread("Task\F2.wav");
[f3,fs_f3] = audioread("Task\F3.wav");
[f4,fs_f4] = audioread("Task\F4.wav");
[f5,fs_f5] = audioread("Task\F5.wav");
[f6,fs_f6] = audioread("Task\F6.wav");
[f7,fs_f7] = audioread("Task\F7.wav");
[f8,fs_f8] = audioread("Task\F8.wav");


Lf1 = length(f1);
Lf2 = length(f2);
Lf3 = length(f3);
Lf4 = length(f4);
Lf5 = length(f5);
Lf6 = length(f6);
Lf7 = length(f7);
Lf8 = length(f8);

fft_f1 = fftshift(fft(f1));
fft_f2 = fftshift(fft(f2));
fft_f3 = fftshift(fft(f3));
fft_f4 = fftshift(fft(f4));
fft_f5 = fftshift(fft(f5));
fft_f6 = fftshift(fft(f6));
fft_f7 = fftshift(fft(f7));
fft_f8 = fftshift(fft(f8));

freq_f1 = fs_f1*(-Lf1/2:Lf1/2-1)/Lf1;
freq_b1 = fs_b1*(-Lb1/2:Lb1/2-1)/Lb1;
freq_b2 = fs_b2*(-Lb2/2:Lb2/2-1)/Lb2;
freq_b3 = fs_b3*(-Lb3/2:Lb3/2-1)/Lb3;

mag_f1 = abs(fft_f1);
mag_b1 = abs(fft_b1);
mag_b2 = abs(fft_b2);
mag_b3 = abs(fft_b3);


% figure;
% plot(fs_b1*(-Lb1/2:Lb1/2 - 1)/Lb1,abs(fft_b1))
% title('Bird 1')
% grid on;

% figure;
% plot(fs_b2*(-Lb2/2:Lb2/2 - 1)/Lb2,abs(fft_b2))
% title('Bird 2')
% grid on;
% 
% figure;
% plot(fs_b3*(-Lb3/2:Lb3/2 - 1)/Lb3,abs(fft_b3))
% title('Bird 3')
% grid on;
% 
% figure;
% plot(fs_f1*(-Lf1/2:Lf1/2-1)/Lf1,abs(fft_f1))
% title('File 1')
% grid on;
% 
% figure;
% plot(fs_f2*(-Lf2/2:Lf2/2-1)/Lf2,abs(fft_f2))
% title('File 2')
% grid on;
% 
% figure;
% plot(fs_f3*(-Lf3/2:Lf3/2-1)/Lf3,abs(fft_f3))
% title('File 3')
% grid on;
% 
% figure;
% plot(fs_f4*(-Lf4/2:Lf4/2-1)/Lf4,abs(fft_f4))
% title('File 4')
% grid on;
% 
% figure;
% plot(fs_f5*(-Lf5/2:Lf5/2-1)/Lf5,abs(fft_f5))
% title('File 5')
% grid on;
% 
% figure;
% plot(fs_f6*(-Lf6/2:Lf6/2-1)/Lf6,abs(fft_f6))
% title('File 6')
% grid on;
% 
% figure;
% plot(fs_f7*(-Lf7/2:Lf7/2-1)/Lf7,abs(fft_f7))
% title('File 7')
% grid on;
% 
% figure;
% plot(fs_f8*(-Lf8/2:Lf8/2-1)/Lf8,abs(fft_f8))
% title('File 8')
% grid on;

f1b1 = xcorr(abs(fft_f1),abs(fft_b1),0,'coeff');
f1b2 = xcorr(abs(fft_f1),abs(fft_b2),0,'coeff');
f1b3 = xcorr(abs(fft_f1),abs(fft_b3),0,'coeff');

disp('Zero Lag Correlation in Frequency Domain : ')
disp(['F1 and B1 ',num2str(f1b1)]);
disp(['F1 and B2 ',num2str(f1b2)]);
disp(['F1 and B3 ',num2str(f1b3)]);

%Correlation of Time
figure;
subplot(3,1,1);
[corr_f1_b1, lags] = xcorr(f1, b1, 'coeff');
plot(lags,corr_f1_b1)
grid on;
title('Correlation of F1,B1 in Time')
xlabel('Lags(\tau)')
ylabel('Corr. Coeff.(\rho)')

subplot(3,1,2);
[corr_f1_b2, lags] = xcorr(f1,b2, 'coeff');
plot(lags,corr_f1_b2)
grid on;
title('Correlation of F1,B2 in Time')
xlabel('Lags(\tau)')
ylabel('Corr. Coeff.(\rho)')

subplot(3,1,3);
[corr_f1_b3, lags] = xcorr(f1,b3, 'coeff');
plot(lags,corr_f1_b3)
grid on;
title('Correlation of F1,B3 in Time')
xlabel('Lags(\tau)')
ylabel('Corr. Coeff.(\rho)')

disp(['Correlation in Time domain : ']);
disp(['Max. of Correlation with F1 ',num2str(max(corr_f1_b1))])
disp(['Max. of Correlation with F2 ', num2str(max(corr_f1_b2))])
disp(['Max. of Correlation with F3 ', num2str(max(corr_f1_b3))])