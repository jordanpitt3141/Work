% Process Fortran Outputs

clc;
clear all;
close all;

% Get list of directories to loop over when reading data
%wdir = "/home/jp/Documents/Work/PostDoc/Projects/Steve/1DWaves/RegularisedSerre/Data/RAW/Models/gSGNForcedLimAll/ConstantBeta/AnaSolSolitonLoop/06/";

wdir = './NR/07/';

xhug = importdata(strcat(wdir, 'End.dat'));
t = xhug(1,1);
x = xhug(:,2);
h = xhug(:,3);
g = xhug(:,4);
u = xhug(:,5);

xhugA = importdata(strcat(wdir, 'EndAna.dat'));
xA = xhugA(:,2);
hA = xhugA(:,3);
gA = xhugA(:,4);
uA = xhugA(:,5);

figure;
plot(xA,hA,'-b');
hold on;
plot(x,h,'.r');
hold off

