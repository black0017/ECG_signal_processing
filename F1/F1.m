clc
clear
close all

% Import audio
y = audioread('118e00m.wav'); 
INFO = audioinfo('118e00m.wav'); 

% Remove DC 
x1 = y(:,2);
x1 = x1(1:104400);
x1 = (x1 - mean(x1));
Samples = length(x1);

% init signal characteristics
Fs = INFO.SampleRate;
Ts = 1/Fs;
Nbits = INFO.BitsPerSample;
%duration = INFO.Duration;

duration = Samples/Fs ;

% 2 Hz HighPass
fcut_highpass = 2 ; % hz
fcut = fcut_highpass / (Fs/2); % normalized freq
bH = fir1(20, fcut, 'high');
x1Filt = filter(bH, 1, x1);

% 10 Hz Lowpass
fcut_lowpass = 18;
fcut2 = fcut_lowpass / (Fs/2); % normalized freq
bH2 = fir1(100, fcut2, 'low');
x1Filt2 = filter(bH2, 1, x1Filt);

% Remove 50 Hz 

bH2 = fir1(48, [49.5 50.5]/(Fs/2), 'stop');
x1Filt2 = filter(bH2, 1, x1Filt2);
figure('Name', '50Hz Bandpass')
freqz(bH2, 1, 2^16, Fs)



% constructing Frequency and Time vectors for Plots
t = 0:Ts:duration-Ts;
f = linspace(0, (Fs/2), (Fs*duration/2));

% Compute Signal FFT / Magnitude / Phase
X1 = fft(x1);
mX1 = 20 * log10(abs(X1));

X1Filt = fft(x1Filt);
mX1Filt = 20 * log10(abs(X1Filt));

X1Filt2 = fft(x1Filt2);
mX1Filt2 = 20 * log10(abs(X1Filt2));


% -------------------- Plots --------------------
view_samples = 800;
% Signal in Time Domain
figure('Name','Time Domain')

subplot(2, 1, 1);
plot(t(1:view_samples), x1(1:view_samples));
xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title('ECG Original Signal(Time Domain)');

grid on;
%axis([0 duration -1 1]);
subplot(2, 1, 2);
plot(t(1:view_samples), x1Filt2(1:view_samples));
grid on;
%axis([0 duration -1 1]);

xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title('ECG Filtered Signal (Time Domain)');


% Signal in Time Domain
figure('Name','Time Domain')
subplot(3, 1, 1);
plot(t, x1);
grid on;
%axis([0 duration -1 1]);

xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title('ECG Original Signal (Time Domain)');
subplot(3, 1, 2);
plot(t, x1Filt);
grid on;
%axis([0 duration -1 1]);

xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title('ECG Filtered Signal (Time Domain)');
subplot(3, 1, 3);
plot(t, x1Filt2);
grid on;
%axis([0 duration -1 1]);

xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title('ECG Filtered Signal 2 (Time Domain)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Signal in Frequency Domain
figure('Name','Frequency Domain')
subplot(2, 1, 1);
semilogx(f, mX1(1:floor(length(X1)/2))); % Magnitude
grid on;
axis([0 Fs/2 0 100]);
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)');
title('ECG Original Signal (Frequency Domain)');
subplot(2, 1, 2);
semilogx(f, mX1Filt2(1:floor(length(X1Filt)/2))); % Magnitude
grid on;
axis([0 Fs/2 0 100]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('ECG Filtered Signal (Frequency Domain)');

