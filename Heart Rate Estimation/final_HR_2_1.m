% Load the signal
load('E1.mat'); 
fs = 128; % Sampling frequency

% Extract a portion of the signal for analysis
E1 = E1(5000:5500); 
time = (0:length(E1)-1) / fs; % Time vector

% Compute the threshold for R-wave detection
threshold = 1.5 * rms(E1); % Adjust threshold (scaling factor = 1.5)

% Estimate mean RR interval for setting minimum peak distance
[~, peaks_initial] = findpeaks(E1); 
RR_intervals_initial = diff(peaks_initial) / fs;
s = fix(mean(RR_intervals_initial) * fs); % Approximate RR interval in samples

% Detect peaks with stricter criteria
[amp, peaks] = findpeaks(E1, 'MinPeakDistance', s, 'MinPeakProminence', 0.1, 'MinPeakWidth', 2);

% Identify R-wave points based on amplitude threshold
rwave = amp > threshold; % R-wave condition
rdots = zeros(1, length(E1)); % Initialize R-wave points
ndots = zeros(1, length(E1)); % Initialize non-R-wave points

% Separate R-wave and non-R-wave points
rdots(peaks(rwave)) = E1(peaks(rwave)); % R-wave points
ndots(peaks(~rwave)) = E1(peaks(~rwave)); % Non-R-wave points

% Calculate heart rate (HR) for valid R-wave intervals
valid_peaks = peaks(rwave); % Use only R-wave peaks
RR_intervals = diff(valid_peaks) / fs; % RR intervals in seconds
HR = 60 ./ RR_intervals; % Heart rate in BPM
HR_time = time(valid_peaks(2:end)); % Time corresponding to HR values

% Plot the signal with detected peaks
figure;

% Top subplot: Original signal with R-wave and non-R-wave points
subplot(2, 1, 1);
plot(time, E1, 'b'); % Plot signal
hold on;
plot(time, rdots, 'r*', 'LineWidth', 1.5); % R-wave points in red
plot(time, ndots, 'b*', 'LineWidth', 1.5); % Non-R-wave points in blue
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Signal with Detected Peaks');
legend('Signal', 'R-wave Points', 'Non-R-wave Points');
grid on;

% Bottom subplot: Heart rate as a function of time
subplot(2, 1, 2);
plot(HR_time, HR, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Heart Rate (BPM)');
title('Heart Rate as a Function of Time');
grid on;
