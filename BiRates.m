
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
[figs1]=mle_figures(info,MLE_meancat);


MLE_results


% [siminfo,sim]=cat_gen(info,MLE_meancat); 
% [simstat1]=cat_stat(info,siminfo,sim);
% [simstat]=cat_stat_test(info,simstat1)
% [figs2]=make_fig(info,siminfo,simstat);






    