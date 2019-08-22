clc
clear
close all
% Import audio
y = audioread('F3n.wav'); 
INFO = audioinfo('F3n.wav'); 
% Remove DC 
x1 = y;
%x1 = x1(1:104400);
x1 = (x1 - mean(x1));
Samples = length(x1);
% init signal characteristics
Fs = INFO.SampleRate;
Ts = 1/Fs;
Nbits = INFO.BitsPerSample;
%duration = INFO.Duration;
duration = Samples/Fs ;
% constructing Frequency and Time vectors for Plots
t = 0:Ts:duration-Ts;
f = linspace(0, (Fs/2), (Fs*duration/2));
% Compute Signal FFT / Magnitude / Phase
X1 = fft(x1);
mX1 = 20 * log10(abs(X1));
% -------------------- Plots --------------------
view_samples = 30000;
% Signal in Time Domain
figure('Name','Time Domain')
plot(t(1:view_samples), x1(1:view_samples));
xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title('ECG Original Signal(Time Domain)');
grid on;
% Signal in Time Domain
figure('Name','Time Domain')
plot(t, x1);
grid on;
xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title(' Original Signal (Time Domain)');
% Signal in Frequency Domain
figure('Name','Frequency Domain')
semilogx(f, mX1(1:floor(length(X1)/2))); % Magnitude
grid on;
axis([0 Fs/2 0 100]);
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)');
title('Original Signal (Frequency Domain)');

%%

f_band_pass = 4410;
margin = 2;
order = 60 ;
f1 = f_band_pass - margin ;
f2 = f_band_pass + margin ; 

bH2 = fir1(order, [f1 f2 ]/(Fs/2), 'bandpass');
x2 = filter(bH2, 1, x1);
figure('Name', '50Hz Bandpass')
freqz(bH2, 1, 2^16, Fs)


X2 = fft(x2);
mX2 = 20 * log10(abs(X2));



view_samples = 30000;
% Signal in Time Domain
figure('Name','Time Domain')
plot(t(1:view_samples), x2(1:view_samples));
xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title('Filtered Signal(Time Domain)');
grid on;
% Signal in Time Domain
figure('Name','Time Domain')
plot(t, x2);
grid on;
xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title('Filtered Signal (Time Domain)');
% Signal in Frequency Domain
figure('Name','Frequency Domain')
semilogx(f, mX2(1:floor(length(X2)/2))); % Magnitude
grid on;
axis([0 Fs/2 0 100]);
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)');
title('Filtered Signal (Frequency Domain)');

%%


fcut_highpass = 40;
fcut = fcut_highpass / (Fs/2); % normalized freq
bH2 = fir1(120, fcut, 'high');
x2 = filter(bH2, 1, x2);

X2 = fft(x2);
mX2 = 20 * log10(abs(X2));


view_samples = 30000;
% Signal in Time Domain
figure('Name','Time Domain')
plot(t(1:view_samples), x2(1:view_samples));
xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title('Filtered Signal(Time Domain)');
grid on;
% Signal in Time Domain
figure('Name','Time Domain')
plot(t, x2);
grid on;
xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title('Filtered Signal (Time Domain)');
% Signal in Frequency Domain
figure('Name','Frequency Domain')
semilogx(f, mX2(1:floor(length(X2)/2))); % Magnitude
grid on;
axis([0 Fs/2 0 100]);
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)');
title('Filtered Signal (Frequency Domain)');

