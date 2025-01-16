close all;
load('E1.mat'); 
fs = 128;
% E1 = E1(5000:5500);

ECG_diff = diff(E1);
ECG_squared = ECG_diff .^ 2;

time1 = (0:length(E1)-1) / fs;
time2 = (0:length(E1)-2) / fs;

window_size = round(0.12 * fs); 
ECG_ma = movmean(ECG_squared, window_size);

% Debugging plot: visualize ECG_ma and threshold
threshold = 0.4 * max(ECG_ma); % Lower threshold to 40%
figure;
plot(time2, ECG_ma);
hold on;
yline(threshold, '--r', 'Threshold');
xlabel("Time (s)");
ylabel("Smoothed ECG Signal");
title("Smoothed Signal with Threshold");
legend("Smoothed Signal", "Threshold");

% Adjust MinPeakDistance if peaks are too close or too far apart
[peaks, locs] = findpeaks(ECG_ma, 'MinPeakHeight', threshold, 'MinPeakDistance', round(0.15 * fs));

RR_intervals = diff(locs) / fs; 
HR = 60 ./ RR_intervals;
HR_time = time1(locs(2:end));

% Plot original signal and detected peaks
figure;
subplot(2,1,1);
plot(time1, E1);
hold on;
plot(time2(locs), ECG_ma(locs), 'r*'); % Highlight detected peaks
xlabel("Time (s)");
ylabel("ECG Signal");
legend("Original Signal", "Detected Peaks");
title("Original Signal with Detected Peaks");

subplot(2,1,2);
plot(time2, ECG_ma);
hold on;
plot(time2(locs), ECG_ma(locs), 'ro');
xlabel("Time (s)");
ylabel("Smoothed ECG Signal");
legend("Smoothed Signal", "Detected Peaks");
title("Smoothed ECG Signal with Detected Peaks");

% Plot Heart Rate over time
figure;
if ~isempty(HR)
    plot(HR_time, HR);
    xlabel("Time (s)");
    ylabel("Heart Rate (bpm)");
    title("Heart Rate Over Time");
else
    disp('Not enough peaks detected to compute HR.');
end

figure;
plot(fs*(-length(E1)/2:(length(E1)-1)/2)/length(E1),fftshift(abs(fft(E1))));
