# R_1_ROC
##Aim:
The aim of this web application is to compute the ROC curve of a measured variable and a target (two-state) variable provided by the user. It also provides the sensitivity and specificity for all the available threshold values together with their corresponding bootstrap confidence intervals following Carpenter and Bithell (2000).

James Carpenter and John Bithell (2000) “Bootstrap confidence intervals: when, which, what? A practical guide for medical statisticians”. Statistics in Medicine 19, 1141–1164.

##User guide:
You need to follow the steps in the left-side panel in order to conduct the ROC analysis. At first the selected data file must be uploaded to the application that contains the binary target variables and the continuous measured variables that we want to identify the optimal threshold. 
A summary of all the variables included in the dataset is also available in `Show Summary`. Raw data can be examined in the `Show Data` tab. 
After data has been loaded, the target variable and the measured variable must be chosen in `Select Variables` before the ROC Analysis is conducted in `Compute ROC Curve` tab. 
The output consists of the ROC curve for all the possible thresholds (axis: Sensitivity, 1-Specificity) and the corresponding data in tabular format. In the output table, the sensitivity and specificity values with the respective bootstrap 2.5% and 97.5% confidence intervals for each threshold value are provided followed by the Positive Predictive value (PPV, Precision) and the Negative Predictive Value (NPV).


The current web application has been developed by Sonia Malefaki as a contribution to the Free and Open Source seminar in R organized by the University of Patras, Greece in May 2015.
