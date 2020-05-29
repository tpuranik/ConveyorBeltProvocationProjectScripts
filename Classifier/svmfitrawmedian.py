'''
SVM Classifier that looks at median power EEG to predict OCD stress. Currently has 
~70-80% accuracy
'''

import numpy as np
import pandas as pd
import scipy as sp
from sklearn import svm
from scipy.io import loadmat
import h5py
import matplotlib.pyplot as plt
from sklearn.model_selection import KFold
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
import matplotlib.pyplot as plt
from sklearn import svm, datasets


#Input variables
subject=''
condition='' #Scon1 or Scon2
electrode='' #electrode number (1,2,3,....)
frequencyband='' #delta(1),theta(2)...
rating1or2=3 #1 is rating 1 only, 2 is rating 2 only, 3 is both together


#import files
filepath='' #path to saved median data
filename=subject+condition+'median.mat'
file=filepath+filename
arrays = {}
f = h5py.File(file) #for datasets that are lower than v7.3, need to use this
for k, v in f.items():
    arrays[k] = np.array(v)
#print(arrays)

'''
#arrays:
 0]=fitobject: slope rating 1
 [1]=fitobject2: slope rating 2
 [2]=gamma_t: median values for each frequency band rating 1
 [3]=gamma_t2: median values for each frequency band rating 2
 [4] X_T: x values rating 1
 [5] X_T2: x values rating 2
'''

channel=(electrode-1)*9+7
fitobject=arrays['fitobject']
fitobject2=arrays['fitobject2']
length180=len(fitobject[0])
r1=arrays['gamma_T']
rating1try=r1
rating1ex=r1[:][0]
rating1ex = rating1ex[~np.isnan(rating1ex)]
rating1try = rating1try[~np.isnan(rating1try)]#problem:loses shape
print('rating1ex',rating1ex)
l1=len(rating1ex)
print('l1',l1)
rating1=r1[0:length180,0:l1]
print('rating1',rating1try)
r1x=arrays['X_T']
rating1x=r1x[0,0:l1]
#len(r2[0])=50


r2=arrays['gamma_T2']
rating2ex=r2[:][0]
rating2ex = rating2ex[~np.isnan(rating2ex)]
l2=len(rating2ex)
rating2=r2[0:length180,0:l2]
#print('rating1',len(rating1),len(rating1[0]),l2)
r2x=arrays['X_T2']
rating2x=r2x[0,0:l2]
total=[fitobject,fitobject2,rating1,rating2,rating1x,rating2x]
#print(fitobject)
#print(rating1)

label1=np.zeros([l1,1])
label2=np.zeros([l2,1])
label=np.zeros([length180,1])
#print(label2)

#Defining X values depending on dataset for examination (r1, r1, or all)
if rating1or2==1:
	X = rating1[channel,:] #for individual values
	#print('Xbefore',X)
	X = X[~np.isnan(X)]
	#print('Xafter',X)
	r1x=arrays['X_T']
	rating1x=r1x[channel,0:l1]
	rating1x=rating1x[~np.isnan(rating1x)]
	label1=rating1x
	#print('label1',label1)
if rating1or2==2:
	X = rating2[channel,:] #for individual values
	#print('Xbefore',X)
	X = X[~np.isnan(X)]
	#print('Xafter',X)
	r2x=arrays['X_T2']
	rating2x=r2x[channel,0:l2]
	rating2x=rating2x[~np.isnan(rating2x)]
	label1=rating2x
	#print('label2',label1)
if rating1or2==3: #total
	X1= rating1[channel,:] #for individual values
	X1 = X1[~np.isnan(X1)]
	r1x=arrays['X_T']
	rating1x=r1x[channel,0:l1]
	rating1x=rating1x[~np.isnan(rating1x)]
	X2 = rating2[channel,:] #for individual values
	X2 = X2[~np.isnan(X2)]
	r2x=arrays['X_T2']
	rating2x=r2x[channel,0:l2]
	rating2x=rating2x[~np.isnan(rating2x)]
	label1=list(rating1x)+list(rating2x)
	label1=np.array(label1)
	X=list(X1)+list(X2)
	X=np.array(X)
print('X',X,len(X))

#Defining class labels (y)
b=max(label1)
c=min(label1)
#print('minandmax',b,c)
a=b-2; #automatically defining high rating values as largest three values
#for label1: its 0 
for i in range(10):
	if i<a:
		label1=[0 if e == i else e for e in label1]
	elif i>=a:
		label1=[2 if e == i else e for e in label1]

#print('label1',label1)
y = label1 
Y=np.asarray(y) #list to array for formatting reasons

#Kfold Indices
kf = KFold(n_splits=5, random_state=None,shuffle=True)
kf.get_n_splits(X)
#print('kf',kf)
#print('Y',len(Y),'X',len(X))
print('Y',Y)
for train_index, test_index in kf.split(X):
	X_train, X_test = X[train_index], X[test_index]
	y_train, y_test = Y[train_index], Y[test_index]
	#print('text_index',Y[train_index],train_index)
print("TRAIN:", train_index, "TEST:", test_index)
print('sizes',len(X_train),len(X_test))
xtrainlen=len(X_train)
xtestlen=len(X_test)
X_train=np.asarray(X_train)


#Classifier
clf = svm.SVC(C=1000) #higher C solved problem
X_train=X_train.reshape((xtrainlen,1)) #reshaping for function recognition
y_train=y_train.reshape((xtrainlen,1))
y_t=clf.fit(X_train, y_train)


result = clf.decision_function(X_train)
a=clf.predict(X_train)
X_test=X_test.reshape((xtestlen,1))
aa=clf.predict(X_test)


m=confusion_matrix(y_test,aa)#(y_test, y_pred)
print('confusion matrix with test',m)
print('accuracy score with test',accuracy_score(y_test, aa))

m1=confusion_matrix(y_train,a)#(y_test, y_pred)
print('confusion matrix for trained data',m1)
print('accuracy score for trained data',accuracy_score(y_train,a))


# Plotting Classifier Results
x = X_train
xpoints=np.arange(int(x.min()), int(x.max())+1,0.2).tolist()

y = y_train
def make_meshgrid(x, y, h=.02):
    x_min, x_max = x.min() - 1, x.max() + 1
    y_min, y_max = y.min() - 1, y.max() + 1
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
    return xx, yy

def plot_contours(ax, clf, xx, yy, **params):
    Z = clf.predict(np.c_[xx.ravel()])
    Z = Z.reshape(xx.shape)
    out = ax.contourf(xx, yy, Z, **params)
    return out

fig, ax = plt.subplots()
title = ('Decision surface of linear SVC, Channel:',channel,'Subject',subject)

searchval = 2
ii = np.where(y_train == searchval)[0]
searchval = 0
i2 = np.where(y_train == searchval)[0]
print('indices',ii,i2)

xx,yy = make_meshgrid(x,y)

plot_contours(ax, clf, xx,yy, cmap=plt.cm.coolwarm, alpha=0.8)
ax.scatter(x,y, c=y, cmap=plt.cm.coolwarm, s=20, edgecolors='k')
ax.scatter(X_test,y_test, c='k', cmap=plt.cm.coolwarm, s=20,  edgecolors='k')

plt.ylim(y.min()-1, y.max()+1)
plt.xlim(x.min()-1, x.max()+1)
ax.set_ylabel('Ratings, 0=low ratings, 2=high ratings')
ax.set_xlabel('Median Power Value (uV^2)')
ax.set_xticks((xpoints))
ax.set_yticks((0,2))
ax.set_title(title)
ax.legend()
plt.show()

