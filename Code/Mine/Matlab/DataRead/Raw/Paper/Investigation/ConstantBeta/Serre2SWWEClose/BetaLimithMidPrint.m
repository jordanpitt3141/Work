% Process Fortran Outputs

clc;
clear all;
close all;

% Get list of directories to loop over when reading data
%wdir = "/home/jp/Documents/Work/PostDoc/Projects/Steve/1DWaves/RegularisedSerre/Data/RAW/Models/gSGNForcedLimAll/ConstantBeta/AnaSolDBLoop/theta1/08/";
%wdir = "/home/jp/Documents/Work/PostDoc/Projects/Steve/1DWaves/RegularisedSerre/Data/RAW/Models/SWWE/AnaSolDBLoop/theta1/07/"

wdirbase = "/home/jp/Documents/Work/PostDoc/Projects/Steve/1DWaves/RegularisedSerre/Data/RAW/Models/gSGNForcedLimAll/ConstantBeta/SmoothDBInvestigation/Serre2SWWEClose/";
wdir = "AspRat2to1/DBalpha0p1/Beta";
dxdir = '/dx06/';

dx = 7.8126220722198776E-003;
scenbeg = -250;
scenend = 250;

linestart = 30;
lineend = 60;
linestarti = round(((linestart - scenbeg)/dx));
lineendi = round(((lineend - scenbeg)/dx));
linesep = 3;

kstart = 20;
ksep = -10;
kend = 0;
figure;
hold on;
for k = [kstart:ksep:kend]
    BetaNumStr = compose("%2.2d",k);
    expdir = strcat(wdirbase,wdir,BetaNumStr,dxdir);
   
    End = importdata(strcat(expdir,'End.dat' ));
    param = fileread(strcat(expdir ,'Params.dat' ));

    beta1str = extractBetween(param,"beta1 :","beta2");
    beta1 = str2double(beta1str{1,1});

    beta2str = extractAfter(param,"beta2 :");
    beta2 = str2double(beta2str);
    
    t = End(1,1);
    x = End(linestarti:linesep:lineendi,2);
    h = End(linestarti:linesep:lineendi,3);
    G = End(linestarti:linesep:lineendi,4);
    u = End(linestarti:linesep:lineendi,5);

    plot(x,h,'-','DisplayName',strcat('\beta_1=',num2str(beta1)));
    xlabel('x (m)');
    ylabel('h (m)');
    
end

EndA = importdata(strcat(expdir,'EndAna.dat' ));
tA = EndA(1,1);
xA = EndA(linestarti:linesep:lineendi,2);
hA = EndA(linestarti:linesep:lineendi,3);
GA = EndA(linestarti:linesep:lineendi,4);
uA = EndA(linestarti:linesep:lineendi,5);

plot(xA,hA,'--k','DisplayName','SWWE Dambreak Solution');

axis([30 60 1.42 1.49])
xticks([30,35,40,45,50,55,60])
yticks([1.42,1.43,1.44,1.45,1.46,1.47,1.48,1.49])
legend('hide')
hold off

% matlab2tikz('hMid.tex');
