close all;
load('E3.mat');
E3=E3(500:1500);
fs = 128;
notch_freqs = [22, 50];
filtered_E3 = E3;

for f = notch_freqs
    BW = 0.1;
    [b, a] = iirnotch(f / (fs / 2), BW);
    filtered_E3 = filtfilt(b, a, filtered_E3);
end


ECG_diff = diff(filtered_E3);
ECG_squared = ECG_diff .^ 2;

time1 = (0:length(E3)-1) / fs;
time2 = (0:length(ECG_squared)-1) / fs;

window_size = round(0.15 * fs); 
ECG_ma = movmean(ECG_squared, window_size);

threshold = 0.4 * max(ECG_ma); % Adjusted to 30% of the maximum
[peaks, locs] = findpeaks(ECG_ma, 'MinPeakHeight', threshold, 'MinPeakDistance', round(0.3 * fs));

RR_intervals = diff(locs) / fs; 
HR = 60 ./ RR_intervals;
HR_time = time1(locs(2:end));

figure;
subplot(2,1,1);
plot(time1, E3);
title("Original ECG Signal");
ylabel("Amplitude");
xlabel("Time (s)");

subplot(2,1,2);
plot(time1, filtered_E3);
title("filtered E3 by notch");
ylabel("Amplitude");
xlabel("Time (s)");



figure;
subplot(2,1,1);
plot(filtered_E3);
subplot(2,1,2);
plot(time2, ECG_ma, 'b');
hold on;
plot(time2(locs), ECG_ma(locs), 'ro');
title("ECG Moving Average with Detected Peaks");
xlabel("Time (s)");
ylabel("Amplitude");
legend("ECG Moving Average", "Detected Peaks");

figure;
if ~isempty(HR)
    plot(HR_time, HR, 'r');
    title("Heart Rate Over Time");
    xlabel("Time (s)");
    ylabel("Heart Rate (bpm)");
else
    disp("Not enough peaks detected for heart rate calculation.");
end

figure;
subplot(2, 1, 1);
plot(fs * ((-length(E3)/2 : (length(E3)-1)/2) / length(E3)), fftshift(abs(fft(E3))));
title("Original ECG Signal FFT");
xlabel("Frequency (Hz)");
ylabel("Magnitude");

subplot(2, 1, 2);
plot(fs * ((-length(filtered_E3)/2 : (length(filtered_E3)-1)/2) / length(filtered_E3)), fftshift(abs(fft(filtered_E3))));
title("Filtered ECG Signal FFT");
xlabel("Frequency (Hz)");
ylabel("Magnitude");
