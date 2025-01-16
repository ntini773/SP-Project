% Load the ECG signals
load('E2.mat'); % Replace with your file or variable containing E2
load('E3.mat'); % Replace with your file or variable containing E3
fs = 128; % Sampling rate in Hz
time = (0:length(E2)-1) / fs; % Time vector

% Define filter parameters
low_cutoff = 0.5; % Lower cutoff frequency (Hz)
high_cutoff = 50; % Higher cutoff frequency (Hz)
[b_bandpass, a_bandpass] = butter(4, [low_cutoff high_cutoff] / (fs / 2), 'bandpass');

% Apply bandpass filter
E2_filtered = filtfilt(b_bandpass, a_bandpass, E2);
E3_filtered = filtfilt(b_bandpass, a_bandpass, E3);

% R-peak detection for E2
[~, locs_R_E2] = findpeaks(E2_filtered, 'MinPeakHeight', 0.5, 'MinPeakDistance', 0.6 * fs);
RR_intervals_E2 = diff(locs_R_E2) / fs; % RR intervals in seconds
HR_E2 = 60 ./ RR_intervals_E2; % HR in BPM
HR_time_E2 = time(locs_R_E2(2:end)); % Time for HR

% R-peak detection for E3
[~, locs_R_E3] = findpeaks(E3_filtered, 'MinPeakHeight', 0.5, 'MinPeakDistance', 0.6 * fs);
RR_intervals_E3 = diff(locs_R_E3) / fs; % RR intervals in seconds
HR_E3 = 60 ./ RR_intervals_E3; % HR in BPM
HR_time_E3 = time(locs_R_E3(2:end)); % Time for HR

% Plot results for E2
figure;
subplot(2, 1, 1);
plot(time, E2, 'b'); hold on;
plot(time, E2_filtered, 'r');
title('E2: Original and Filtered Signals');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Original', 'Filtered');
grid on;

subplot(2, 1, 2);
plot(HR_time_E2, HR_E2, '-o', 'LineWidth', 1.5);
title('E2: Heart Rate as a Function of Time');
xlabel('Time (s)');
ylabel('Heart Rate (BPM)');
grid on;

% Plot results for E3
figure;
subplot(2, 1, 1);
plot(time, E3, 'b'); hold on;
plot(time, E3_filtered, 'r');
title('E3: Original and Filtered Signals');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Original', 'Filtered');
grid on;

subplot(2, 1, 2);
plot(HR_time_E3, HR_E3, '-o', 'LineWidth', 1.5);
title('E3: Heart Rate as a Function of Time');
xlabel('Time (s)');
ylabel('Heart Rate (BPM)');
grid on;
