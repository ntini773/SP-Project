close all;
load('E1.mat');
load('E3.mat');
fs = 128; % Sampling frequency

% Validate indexing to avoid errors
% start_index = 500;
% end_index = min(1000, length(E3)); % Ensure the index doesn't exceed signal length
% E3 = E3(start_index:end_index);
E1 = E1(start_index:end_index);

% Apply notch filters to remove specific frequencies
notch_freqs = [22, 50];
filtered_E3 = E3;
for f = notch_freqs
    BW = 0.1; % Bandwidth
    [b, a] = iirnotch(f / (fs / 2), BW);
    filtered_E3 = filtfilt(b, a, filtered_E3);
end

% Apply a bandstop filter to remove additional noise
fc_low_s = 21; 
fc_high_s = 23;
[b, a] = butter(4, [fc_low_s, fc_high_s] / (fs / 2), 'stop');
filtered_E3 = filtfilt(b, a, filtered_E3);

% Apply a low-pass filter to smooth the signal
fc_low = 30; % Lowpass cutoff frequency
[b_low, a_low] = butter(20, fc_low / (fs / 2), 'low');
filtered_E3 = filtfilt(b_low, a_low, filtered_E3);

% Time vectors for plotting
time1 = (0:length(E3)-1) / fs;
time2 = (0:length(filtered_E3)-1) / fs;

% Plot the filtered signal
figure;
plot(time2, filtered_E3);
title("Smoothed and Filtered E3");
xlabel("Time (s)");
ylabel("Amplitude");

% Differentiation and squaring for peak detection
ECG_diff = diff(filtered_E3);
ECG_squared = ECG_diff .^ 2;

% Moving average filter for peak detection
window_size = round(0.12 * fs); 
ECG_ma = movmean(ECG_squared, window_size);

% Peak detection
threshold = 0.1 * max(ECG_ma); 
[peaks, locs] = findpeaks(ECG_ma, 'MinPeakHeight', threshold, 'MinPeakDistance', round(0.3 * fs));

% Calculate heart rate
RR_intervals = diff(locs) / fs; 
HR = 60 ./ RR_intervals;
HR_time = time1(locs(2:end));

HR = 60 ./ RR_intervals;  

average_HR = mean(HR);

disp(['Average Heart Rate: ', num2str(average_HR), ' bpm']);


% Plot heart rate
figure;
plot(HR_time, HR);
title("Heart Rate Over Time");
xlabel("Time (s)");
ylabel("Heart Rate (bpm)");

% Plot original and filtered signals
figure;
subplot(2, 1, 1);
plot(time1, E3);
title("Original E3 Signal");
xlabel("Time (s)");
ylabel("Amplitude");

subplot(2, 1, 2);
plot(time2, filtered_E3);
title("Filtered E3 Signal");
xlabel("Time (s)");
ylabel("Amplitude");

% Compute FFTs for original and filtered signals
e1_fft = fft(E1);
e3_fft = fft(filtered_E3);

% % Compare FFT magnitudes
% figure;
% plot(fs * ((-length(E3)/2 : (length(E3)-1)/2) / length(E3)), fftshift(abs(e3_fft) - abs(e1_fft)));
% title("FFT Difference Between Filtered and Original Signals");
% xlabel("Frequency (Hz)");
% ylabel("Magnitude Difference");


time3 = (0:length(ECG_ma)-1) / fs;
% Plot ECG moving average with detected peaks
figure;
plot(time3, ECG_ma, 'b');
hold on;
plot(time2(locs), ECG_ma(locs), 'ro');
title("ECG Moving Average with Detected Peaks");
xlabel("Time (s)");
ylabel("Amplitude");
legend("ECG Moving Average", "Detected Peaks");
