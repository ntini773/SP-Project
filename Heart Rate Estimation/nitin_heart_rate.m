% Load the ECG signal E1
load('E1.mat'); 
fs = 128; % Sampling rate in Hz
time = (0:length(E1)-1) / fs; % Time vector
E1 = E1(5000:5500);
% Step 1: Detect R-peaks
[~, locs_R] = findpeaks(E1, 'MinPeakHeight', 0.5, 'MinPeakDistance', 0.6 * fs);

% Step 2: Calculate RR intervals and HR
RR_intervals = diff(locs_R) / fs; % Time differences between R-peaks in seconds
HR = 60 ./ RR_intervals; % Convert RR intervals to BPM

% Step 3: Generate time points for HR
HR_time = time(locs_R(2:end)); % Time corresponding to each RR interval

% Step 4: Plot the HR as a function of time
figure;
plot(HR_time, HR, 'LineWidth', 1);
xlabel('Time (s)');
ylabel('Heart Rate (BPM)');
title('Heart Rate as a Function of Time');
grid on;
