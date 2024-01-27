# Cell-profile-a-tool-to-classify-cell-in-expressing-different-fluorescence-labeled-molecules.
This is a tool to identify the cell nucleus with a Weka-trained model. These identified nucleus is classified by fluorescence positive or negative cell according to auto-threshold or user defined threshold.
Two versions are available in this repository. Otsu and  MaxEntropy methods are used to define thresholds of red and green channels respectively in the autothreshold version. 
User interactive threshold can be implemented in another version. After identifing nucleuses, users will be ask to define the thresholds of both red and green channels. 

## Goal
Classify cells with different expression of fluorescence labeled molecules

## Modality
Widefield fluorescence microscopy

## Image
Nuclear channel and additional channels for different fluorescence labels

## Sample
Tissue section of mice
