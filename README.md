# Code for the biomedical signal processing assignment implemented in Matlab (September 2018): ECG signal processing.

You can reproduce the results running the corresponding scripts.

### F1. Remove artifacts and noise

#### Vizualizing the original and the final signal in the time domain:
![Alt text](./figures/ecg.png?raw=true "title")


#### Vizualizing the original and the final signal in the frequency domain:
![Alt text](./figures/f1.png?raw=true "title")


#### Zooming in: Original and the final signal in the time domain
![Alt text](./figures/f2a.png?raw=true "title")

#### We observe that high frequency noise is eliminated.


### F2. Eliminate noise and mean heart rate (BPM- beats per minute)
#### Estimation of average heart rate after noise removal.
![Alt text](./figures/f2b.png?raw=true "title")

The frequency domain before and after the application of filters is illustrated below. The signal noise is significanlty reduced.
![Alt text](./figures/f3a.png?raw=true "title")

![Alt text](./figures/f3b.png?raw=true "title")

### F3. Eliminte artificial added noise
#### The original signal in time domain:

![Alt text](./figures/f4a.png?raw=true "title")

#### The processed signal in time domain :

![Alt text](./figures/f4b.png?raw=true "title")

