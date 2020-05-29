##Annotating data for functional connectivity analysis and classifer

import h5py
import numpy as np
import mne
import matplotlib.pyplot as plt
from scipy.io import loadmat
import pandas as pd
from mne.io import read_raw_fieldtrip
from numpy import asarray
from numpy import savetxt
from numpy import save


#Input variables
subject=''
#import files
filepath='filepath to EEG from fieldtrip'
file=subject+'EEG.mat'
file1='file for ft_data'

#importing time files
time=loadmat('downsampled time values from data')

#Approach 1: Formatting EEG and creating timepoints with labels
#advantages: in data structure that is more accessible and modifiable for classifier work

conveyorstart=time['conveyorstart']
dialpushedstart=time['dialpushedstart']
ratingstart=time['ratingstart']
movingend=time['movingend']
fs=1000
fs_old=30000
cutoff=1

#Loading .mat files with filtered EEG information
arrays = {}
f = loadmat(file)
arrays=f['EEG'] #assigning variable
rowlength=len(arrays[0][1])
columnlength=len(arrays[0][1][0])
print('array',columnlength)
chan = [ [ 0 for i in range(rowlength) ] for j in range(20)] 
for i in range(20):
	chan[i]= np.asarray(arrays[0][i])

'''
#Creating timepoint arrays with start and stop points of different periods 
#Start and end tagged based on inputted values. 
Following points tagged:
1. Start of Conveyor Belt Movement
2. Rating Period 1
3. Start of Holding Period
4. Start of Rating Period 2
Sampling rate is 

'''
#eventtimes=combination of order

def event_times(cutoff,ratingstart,dialpushedstart):
	eventtimes=[0]*4*39
	c=2 #counter for conveyor start
	o=4 #counter for
	eventtimes[0]=0 #start of task values before first conveyor movement
	eventtimes[1]=5
	eventtimes[2]=10
	eventtimes[3]=20
	for i in range(38):
		eventtimes[o]=int(ratingstart[c,0]/fs-7-cutoff)
		eventtimes[o+1]=int(ratingstart[c,0]/fs-cutoff)
		eventtimes[o+2]=int(dialpushedstart[0,c]/fs-cutoff)
		eventtimes[o+3]=int(ratingstart[c+1,0]/fs-cutoff)
		o=o+4
		c=c+2
	indices=np.tile(np.array([1,2,3,4]),39) #39 movement times
	s = pd.Series(eventtimes, index=indices)
	return s,eventtimes

s,eventtimes=event_times(cutoff,ratingstart,dialpushedstart)
print('events',s,eventtimes)

savename=subject+'EEG.npy'
save(savename,chan)
savename=subject+'eventtimes.npy'
save(savename,s)



#----------------------------------------------------------------------------------------------------------------------
#Approach 2: using MNE
#advantages: in MNE structure for connectivty analysis
#Making raw datastructure for annotations
channel_names = ['AFz','C3','C4','CPz','Cz','F3','F4','F7','F8','FC1','FC2','FC5','FC6','Fp1','Fp2','FT9','FT10','Fz','T7','T8']
montage = 'standard_1020'
n_channels = 20
channel_types=['eeg']*n_channels
sampling_rate = 1000
info = mne.create_info(channel_names, sampling_rate, channel_types, montage)
raw =mne.io.read_raw_fieldtrip(file1, info, data_name='ft_data')


#loading timepoints 
e=loadmat('loading rating start value')
a=e['ratingstart']
a=a/fs_old #get into seconds    
size=len(a)
a=a.reshape((size,))
a=a.astype(int)
#doing each for 5 seconds

dur= [5]*78 #5 second duration uniformly 
des=['ratingstart1']*78
print('dur',dur)

#annotations
my_annot = mne.Annotations(onset=a,
                           duration=dur,
                           description=des)
print('my annot',my_annot)

raw.set_annotations(my_annot)
print('raw annots',raw)

