clc
clear
close all

% Import audio
y = audioread('119e00m.wav'); 
INFO = audioinfo('119e00m.wav'); 

% Remove DC 
x1 = y(:,1);
%x1 = x1(1:104400);
x1 = (x1 - mean(x1));
Samples = length(x1);

% init signal characteristics
Fs = INFO.SampleRate;
Ts = 1/Fs;
Nbits = INFO.BitsPerSample;
%duration = INFO.Duration;

duration = Samples/Fs ;

% 1 Hz HighPass
fcut_highpass = 1; % hz
fcut = fcut_highpass / (Fs/2); % normalized freq
bH = fir1(20, fcut, 'high');
x1Filt = filter(bH, 1, x1);

% 18 Hz Lowpass
fcut_lowpass = 20;
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
view_samples = 30000;
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


%%  heart rate estimation

s1 = x1Filt2(1:360*290);
s2 = x1Filt2(360*430:360*538);
s3 = x1Filt2(360*670:360*759) ;
s4 = x1Filt2(360*912:360*1008) ;
s5 = x1Filt2(360*1149:360*1256);
s6 = x1Filt2(360*1404:360*1484) ;
s7 = x1Filt2(360*1642:360*1734) ;

s1 = s1 - mean(s1);
s2 = s2 - mean(s2);
s3 = s3 - mean(s3);
s4 = s4 - mean(s4);
s5 = s5 - mean(s5);
s6 = s6 - mean(s6);
s7 = s7 - mean(s7);

signal = [ s1 ; s2 ; s3 ; s4 ; s5 ; s6 ; s7 ]  ;

% only for the second channel
% s_2 = signal(1:600*360) ;
% s_3 = signal(690*360:850*360) ;
% signal = [s_2 ;s_3  ];

duration = length(signal)/Fs  ;

t = 0:Ts:duration-Ts;

S1 = fft(signal);
mS1 = 20 * log10(abs(S1));
f = linspace(0, Fs/2 , (Fs*duration/2));
% Signal in Frequency Domain
figure('Name','Frequency Domain')
semilogx(f, mS1(1:floor(length(S1)/2))); % Magnitude
grid on;
axis([0 Fs/2 0 100]);
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)');
title('ECG Original Signal (Frequency Domain)');


% Signal in Time Domain
figure('Name','Time Domain')
plot(t,signal);

xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title('Concataneted Region Signal (Time Domain)');

[b,a]=butter(10, 10/180, 'high' );
y = filtfilt(b,a,signal); 
y=y.^4;
% Signal in Time Domain
figure('Name','NEW')
plot(t,y);
grid on;
xlabel('Time (sec)');
ylabel('Normalized Amplitude');
title('Filtered & Squared Signal (Time Domain)');

pieces = 28;
step = 10800; % 360 * 30 sec
start =1 ;
stop = 10800 ;
peak_data = zeros(28,1);
plot_data = zeros(30*28,1);
for i=1:28  % channel 1
%for i=1:24 % channel 2
    p = signal(start:stop);
    
    peaks = findpeaks(p);
    numOfPeaks = size(peaks);
    TH = mean(peaks)
    temp =peaks ;
    peaks(peaks<TH)=0 ;
    peaks(peaks>TH)=1 ;
    counter = sum(peaks);
    
    peak_data(i)=counter  ;
        
    start = start + step;
    stop = stop+step;
end

heart_rate = mean(peak_data  ) ;
figure
plot(peak_data)
xlabel('Time every 30 sec');
ylabel('Beats per minute estimation');
title('BPM, Average=76.35');
