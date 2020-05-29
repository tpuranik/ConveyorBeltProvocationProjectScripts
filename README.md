# ConveyorBeltProvocationProjectScripts
Conveyor Belt Provocation Scripts

This work was done by Tanaya Puranik in the Borton Neuromotion Laboratory under the guidance of Dr. David Borton. The goal of the project was OCD biomarker detection for a long-term exposure task. These scripts are a part of the statistical analysis pipeline developed along and do not include the functional connectivity and classifier work. For additional information, interpretation of results, and questions please contact tanayapuranik@gmail.com.

Task Information:
During this task designed by Nicole Provenza in the Borton Lab, a distress-inducing object sits on a conveyor belt that comes closer and farther away from the participant with OCD. The participant rates their distress level at multiple points of the task. The participants were setup with the following EEG electrodes: 'AFZ','C3','C4','CPZ','CZ','F3','F4','F7','F8','FC1','FC2','FC5','FC6','FP1','FP2','FT9','FT10','FZ','T7','T8'
The electrodes are tripolar surface electrodes and data was acquired using the OpenEphys system.

1. Conveyor Belt:
Information for the conveyor belt position, the distress ratings by the participants, and the timings were captured by two rotary encoders.

Order to Execute code:
a) Conveyorbelt1
b) Conveyorbelt2
c) Conveyorbelt3
d) Conveyorbelt4

2. Conveyor Belt Behavior Analysis:
Visual analysis to understand patient response to task.

3. EEG Preprocessing:
Processing EEG signal from task and visualization of EEG signal.
Order to Execute:
a) LoadfiltersandEEG
b)EEGpreprocess
c)EEGsignalverification

4. EEG Analysis:
Extracting data, statistical analysis to detect changes in EEG signal, and visualization of results.
First, perform the morlet wavelet analysis. All scripts are dependent on the output from condition1Scon and condition2Scon, which reformat the large amounts of data from the morlet wavelet analysis.

5. Permutation Test:
Computed adjusted p-value with Bonferroni correction and False Discovery Rate with a permutation test. 
To execute:
a) matrixforpermutationtestfinal
b) permutationexecution
c) BonferroniandFDR
