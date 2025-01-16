% E1=abs(E1).^2;
load('E1.mat'); 
load('E2.mat'); 
fs=128;
E2=E2(5000:5500);
% threshold=rms(E1);
% 
% [~,peaks]=findpeaks(E1);
% time = (0:length(E1)-1) / fs;
% 
% RR_intervals = diff(peaks) / fs; 
% HR = 60 ./ RR_intervals;
% HR_time = time(peaks(2:end));
% 
% s=fix(mean(RR_intervals));
% 
% [amp,peaks]=findpeaks(E1,'MinPeakDistance',s);
% 
% rwave=amp>threshold;
% rdots=zeros(1,length(E1));
% rdots(peaks(rwave))=E1(peaks(rwave));




figure;
% subplot(2,1,1);
plot(time,E2);
hold on;
% plot(time,rdots,'r*');
% % xlim([1 350]);
% xlabel('Samples');
% ylabel('Amplitude');
% title('Original Signal with Detected Peaks');

% subplot(2,1,2);
% plot(HR_time, HR, 'LineWidth', 1);
% % xlim([1 20])
% xlabel('Time (s)');
% ylabel('Heart Rate (BPM)');
% title('Heart Rate as a Function of Time');
% grid on;
