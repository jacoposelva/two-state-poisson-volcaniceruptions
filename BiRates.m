
clc

clear 
close all

addpath('routines')

inputFile = 'input_CampiFlegrei.txt';
volcName = 'Campi Flegrei';
%inputFile = 'input_Vesuvius.txt';
%volcName = 'Vesuvius';
%inputFile = 'input_Ischia.txt';
%volcName = 'Ischia';

pwd

disp('---------------------------')
disp(['Volcano: ' volcName])
disp('---------------------------')

info=set_input(volcName,inputFile);
MLE_results=empirical_MLE(info);
[figs1]=mle_figures(info,MLE_results);

conf_int_all=[0.5:0.1:0.9 0.99];
[fig2] = findConfInt(info,MLE_results,conf_int_all);

MLE_results

