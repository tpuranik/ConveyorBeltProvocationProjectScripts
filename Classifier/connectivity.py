'''
Code for EEG functional connectivity for multiple conditions and frequency bands using
PLI 
Epoch chosen is rating start:

Conditions to test:
1. NP and P separate
2. Low vs high rating Values
3. All rating values
4. Random
'''

import os.path as op

import nibabel
from nilearn.plotting import plot_glass_brain
import numpy as np
from scipy.io import loadmat

import mne
from mne.channels import compute_native_head_t, read_custom_montage
from mne.viz import plot_alignment

from nilearn import datasets
from nilearn import plotting

from mne.io import read_raw_fieldtrip
from mne import read_epochs_fieldtrip, read_evoked_fieldtrip

from mne.connectivity import spectral_connectivity
from mne.viz import circular_layout, plot_connectivity_circle

from random import randint
import h5py
import matplotlib.pyplot as plt

#Input variables
Event='Name of event'
frequency='beta'
fmin = 15.
fmax =30.
condition=2
method='pli'

#Loading freesurfer samples
data_path = mne.datasets.sample.data_path()
subjects_dir = op.join(data_path, 'subjects')
fname_raw = op.join(data_path, 'MEG', 'sample', 'sample_audvis_raw.fif')
bem_dir = op.join(subjects_dir, 'sample', 'bem')
fname_bem = op.join(bem_dir, 'sample-5120-5120-5120-bem-sol.fif')
fname_src = op.join(bem_dir, 'sample-oct-6-src.fif')

#Loading channel
channel_dir='channel location pathway'


#Loading custom montage directory and creating montage
fname_montage_custom='.loc file of channel locations (from eeglab)'
dig_montage = read_custom_montage(fname_montage_custom, head_size=0.095, coord_frame='mri')

#Plotting Montage to check for placement
dig_montage.plot()
fig = dig_montage.plot(kind='3d')
fig.gca().view_init(azim=70, elev=15)
#dig_montage.plot(kind='topomap', show_names=False)

#Matrix of head configuration of montage
trans = compute_native_head_t(dig_montage)

#Defining channel information
channel_names = ['AFz','C3','C4','CPz','Cz','F3','F4','F7','F8','FC1','FC2','FC5','FC6','Fp1','Fp2','FT9','FT10','Fz','T7','T8']
n_channels = 20
channel_types=['eeg']*20 
sampling_rate = 1000
info = mne.create_info(channel_names, sampling_rate, channel_types, dig_montage)

#Downloading file information and creating montage
file1='fieldtrip ftdata file path' #MNE processes at V level, not uV
raw =mne.io.read_raw_fieldtrip(file1, info, data_name='ft_data')
picks = mne.pick_types(raw.info, meg=False, eeg=True, stim=False, eog=False,
                       exclude='bads')
raw.set_montage(dig_montage)
raw.set_eeg_reference(projection=True)

#Event time points 
rstart=loadmat('file point to timepoints')
a=rstart['timepoint file name']/sampling_rate
x,y=len(a),len(a[0])
a=a.reshape((len(a),))
a=a.astype(int)

#Picking Conditions
file='dir to conveyor_behavior'	
#1. get conveyor_behavior loaded
arrays = {}
f = h5py.File(file)
for k, v in f.items():
    arrays[k] = np.array(v)
    	
if condition==2:
	#For low versus high rating: Condition 3
	#Output: create one rating1, rating2, and rating all of rating values
	#file='downloading conveyor_behavior file'
	c=arrays['conveyor_behavior'] #columns 3 and 4 for rating 1 and 2
	Rating1=c[2]
	Rating2=c[3]
	Ratingall=np.concatenate((Rating1,Rating2))

	#Defining indices of low and high rating from conveyor_behavior
	idxlow = np.asarray(np.where(Rating1<5))*2
	idxlow1 = np.asarray(np.where(Rating2<5))*2+1
	idxl=np.concatenate((idxlow,idxlow1),axis=1)
	idxhigh = np.asarray(np.where(Rating2>=5))*2-1
	idxhigh1 = np.asarray(np.where(Rating1>=5))*2
	idxh=np.concatenate((idxhigh,idxhigh1),axis=1)
	idxh=idxh[0] #some time of error with numpy concatenate according to stack 
	idxl=idxl[0]

	#2. Apply indices to rating start or dialpushed or conveyor start
	lowrating=a[idxl]
	highrating=a[idxh]
	lowrating=np.sort(lowrating)
	r2=np.transpose(lowrating) 
	highrating=np.sort(highrating)
	r1=np.transpose(highrating)
elif condition==1:
	#Setting up for NP vs P: Condition 2
	r1=np.concatenate((a[0:26:2,],a[52:78:2,]))
	r2=a[25:52:2,]
elif condition==3:
	#All rating values: Condition 1
	a=rstart['file name of start']/sampling_rate
	x,y=len(a),len(a[0])
	a=a.reshape((len(a),))
	a=a.astype(int)
elif condition==4:
	a = np.arange(30, 60.)*raw.first_samp #from 30 seconds to 60 seconds (if want random sampling at even intervals)


def event_time(sampling_rate,a):
	times=a
	smp = times + raw.first_samp #multiplying by 1000
	events = np.zeros((len(smp), 3), dtype='int') #3 columns
	events[:, 0] = smp.astype('int') #first column has times
	events[:, -1] = 1  #event id
	#event_id, tmin, tmax = 1, -0.2, 0.5 #different sampling
	event_id, tmin, tmax = 1, -1, 1
	epochs = mne.Epochs(raw, events, event_id, tmin, tmax, picks=picks,
                    baseline=(None, 0),reject_by_annotation=None,reject=None, proj=False)
	cov = mne.compute_covariance(epochs, tmax=0.)
	evoked = epochs['1'].average()  
	return events, epochs, times, evoked, cov



if condition<3:
	#Extracting NP and P events
	#Provoking
	events, epochs, times, evoked, cov=event_time(sampling_rate,r1)
	#Nonprovoking
	events1, epochs1, times1, evoked1, cov1 =event_time(sampling_rate,r2)
elif condition>=3:
	events, epochs, times, evoked, cov=event_time(sampling_rate, a)


#Plotting evoked
#evoked.plot_joint()

#Further checking alignment: need encryption device to run the plot_alignment: sanity check for alignment
#plot_alignment(evoked.info, trans=None, show_axes=True, surfaces='head-dense',
#               subject='sample', subjects_dir=subjects_dir)

#Calculating forward and inverse solution
def fwdandinv(fname_src,fname_bem,cov,evoked):
	fwd = mne.make_forward_solution(
    	evoked.info, trans=None, src=fname_src, bem=fname_bem, verbose=True)
	inv = mne.minimum_norm.make_inverse_operator(
    	evoked.info, fwd, cov, verbose=True)
	stc = mne.minimum_norm.apply_inverse(evoked, inv)
	return fwd,inv,stc

fwd,inv,stc=fwdandinv(fname_src,fname_bem,cov,evoked)
sfreq = epochs.info['sfreq']

if condition<3:
	#P spectral connectivity/High Rating
	fwd1,inv1,stc1=fwdandinv(fname_src,fname_bem,cov1,evoked1)
	con, freqs, times, n_epochs, n_tapers = spectral_connectivity(
    	epochs, method=method, mode='multitaper', sfreq=sfreq, fmin=fmin,
    	fmax=fmax, faverage=True, mt_adaptive=True, n_jobs=1)
	#NP spectral connectivity/Low Rating
	con1, freqs1, times1, n_epochs1, n_tapers1 = spectral_connectivity(
    	epochs1, method=method, mode='multitaper', sfreq=sfreq, fmin=fmin,
    	fmax=fmax, faverage=True, mt_adaptive=True, n_jobs=1)
elif condition>=3:
	con, freqs, times, n_epochs, n_tapers = spectral_connectivity(
    	epochs, method=method, mode='multitaper', sfreq=sfreq, fmin=fmin,
    	fmax=fmax, faverage=True, mt_adaptive=True, n_jobs=1)


# Connectivity reshaped for plot_connectivity
con_res = dict()
con_methods = ['pli'] #other options: 'wpli2_debiased', 'ciplv'
con_res = con[:, :, 0]
if condition<3:
	con_res1 = con1[:, :, 0]

#predefined colors for plot
label_colors = [(0.09803921568627451, 0.39215686274509803, 0.1568627450980392, 1.0), 
		(0.09803921568627451, 0.39215686274509803, 0.1568627450980392, 1.0), 
		(0.49019607843137253, 0.39215686274509803, 0.6274509803921569, 1.0), 
		(0.49019607843137253, 0.39215686274509803, 0.6274509803921569, 1.0), 
		(0.39215686274509803, 0.09803921568627451, 0.0, 1.0), 
		(0.39215686274509803, 0.09803921568627451, 0.0, 1.0), 
		(0.8627450980392157, 0.0784313725490196, 0.39215686274509803, 1.0), 
		(0.8627450980392157, 0.0784313725490196, 0.39215686274509803, 1.0), 
		(0.8627450980392157, 0.0784313725490196, 0.0392156862745098, 1.0), 
		(0.8627450980392157, 0.0784313725490196, 0.0392156862745098, 1.0), 
		(0.39215686274509803, 0.0, 0.39215686274509803, 1.0), 
		(0.39215686274509803, 0.0, 0.39215686274509803, 1.0),
		(0.7058823529411765, 0.8627450980392157, 0.5490196078431373, 1.0), 
		(0.7058823529411765, 0.8627450980392157, 0.5490196078431373, 1.0), 
		(0.8627450980392157, 0.23529411764705882, 0.8627450980392157, 1.0), 
		(0.8627450980392157, 0.23529411764705882, 0.8627450980392157, 1.0), 
		(0.7058823529411765, 0.1568627450980392, 0.47058823529411764, 1.0), 
		(0.7058823529411765, 0.1568627450980392, 0.47058823529411764, 1.0),
		(1.0, 0.7529411764705882, 0.12549019607843137, 1.0), 
		(1.0, 0.7529411764705882, 0.12549019607843137, 1.0)] 


# Save the plot order and create a circular layout
label_names=channel_names
node_order = list()
node_order=label_names
node_angles = circular_layout(label_names, node_order, start_pos=90,
                              group_boundaries=[0, len(label_names) / 2])

con_res=con_res.reshape(20,20)
if condition<3:
	con_res1=con_res1.reshape(20,20)
	dif=con_res1-con_res
	dif1=con_res-con_res1 #checking for difference between the two

#Plotting connectivity
plot_connectivity_circle(con_res, label_names, n_lines=300,
                         node_angles=node_angles, node_colors=label_colors,vmin=0.4,
                         title='Connectivity, Condition: PLI '+Event+' '+ frequency+'P')

if condition<3:
	plot_connectivity_circle(con_res1, label_names, n_lines=300,
                         node_angles=node_angles, node_colors=label_colors,vmin=0.4,
                         title='Connectivity, Condition: PLI '+Event+' '+ frequency+'NP')

if condition<3:
	#Plotting connections that have difference
	plot_connectivity_circle(dif, label_names, n_lines=300,
                         node_angles=node_angles, node_colors=label_colors, vmin=0.05,
                         title='Connectivity, Condition: PLI '+Event+' '+ frequency+'+')

	plot_connectivity_circle(dif, label_names, n_lines=300,
                         node_angles=node_angles, node_colors=label_colors, vmin=0.05,
                         title='Connectivity, Condition: PLI '+Event+' '+ frequency+'-')

