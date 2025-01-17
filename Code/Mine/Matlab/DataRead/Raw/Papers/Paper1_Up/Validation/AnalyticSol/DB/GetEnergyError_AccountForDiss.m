% Process Fortran Outputs

clc;
clear all;
close all;
format long g;

% Get list of directories to loop over when reading data
wdir = "/home/jp/Documents/Work/PostDoc/Projects/Steve/1DWaves/RegularisedSerre/Data/RAW/Models/gSGN_NoLim/AnalyticSolutions/DBSWWETheta1/"

g= 9.81;
hl = 2;
hr = 1;

kstart = 0
ksep = 1;
kend = 12;
RelErrors = [];
for k = kstart:ksep:kend
    BetaNumStr = compose("%2.2d",k);
    expdir = strcat(wdir,BetaNumStr,'/');
   
    Energy = importdata(strcat(expdir,'Energy.dat' ));
    param = fileread(strcat(expdir ,'Params.dat' ));

    Str1 = extractBetween(param,"dx","tstart ");
    dx = str2double(Str1{1,1});
    
    Str1 = extractBetween(param,"actual end time","dt");
    EndTime = str2double(Str1{1,1});
    
    InitialStr = extractAfter(Energy,"Initial");
    InitialEnergies = sscanf(InitialStr{2,1},'%f');
    InitialEnergies = [InitialEnergies;InitialEnergies(end)];
    
    EndStr = extractAfter(Energy,"End");
    SplitEndStr = split(EndStr{3,1});
    SplitEndStr = SplitEndStr(2:5);
    EndEnergies = str2double(SplitEndStr);
    EndEnergies = [EndEnergies;EndEnergies(end)];
    
    uhflux = 0.5*g*(hl*hl - hr*hr)*EndTime;
    EFlux = DBEN(EndTime,2,1,9.81) - DBEN(0,2,1,9.81);
    FluxEnergies = [0;uhflux;uhflux;0;EFlux];
    
    InitialPlusFlux = InitialEnergies + FluxEnergies ;
    
    Error = EndEnergies - (InitialPlusFlux);
    RelError = abs(Error ./ (InitialPlusFlux));
    RelError = [dx;RelError];
    RelErrors = [RelErrors ,RelError ];

end

RelErrors = RelErrors';

dxs = RelErrors(:,1);
hs = RelErrors(:,2);
Gs = RelErrors(:,3);
uhs = RelErrors(:,4);
Hs = RelErrors(:,5);
dissHs = RelErrors(:,6);

figure;
loglog(dxs,hs,'s b',dxs,Gs,'o r',dxs,uhs,'^ k',dxs,Hs,'x g',dxs,dissHs,'d g')
grid off
legend('h','G', 'uh', 'H','Location','northwest')
xlabel('\Delta x')
ylabel('C_1')
axis([10^-3 1 10^-16 1]);
xticks([10^-4,10^-3,10^-2,10^-1,10^0,10]);
yticks([10^-16,10^-12,10^-8,10^-4,1]);
matlab2tikz('EnergyResults.tex');


function y = h2DB(x,h0,h1,g)
y = x - h1/2*( sqrt( 1+ 8*(2*x/(x - h1) *((sqrt(g*h0) - sqrt(g*x))/ sqrt(g*h1) ))^2 ) -1) ;
end

function DBE = DBEN(t,h0,h1,g)

    if t == 0
        ghEp1 = h0^2*(0 - -250);
        ghEp2 = h1^2*(250);
        DBE = g*(ghEp1 + ghEp2)/2;
    else
        func1 = @(x) h2DB(x,h0,h1,g);
        h2 = fzero(func1,h0);
        u2 = 2*(sqrt(g*h0) -sqrt(g*h2) );
        S2 = 2*h2/(h2 - h1)*(sqrt(g*h0) - sqrt(g*h2));
        
        x0 = -250;
        x1 = -t*sqrt(g*h0);
        x2 = t*(u2 - sqrt(g*h2));
        x3 = t*S2;
        x4 = 250;

        %gh^2
        ghEp1 = h0^2*(x1 - x0);
        Int2 = -2.0/5.0*t*(sqrt(g*h0) - x2/(2*t))^5;
        Int1 = -2.0/5.0*t*(sqrt(g*h0) - x1/(2*t))^5;
        ghEp2 = (4/(9*g))^2*(Int2 - Int1);
        ghEp3 = h2^2*(x3 - x2);
        ghEp4 = h1^2*(x4 - x3);

        gh = g*(ghEp1 + ghEp2 + ghEp3 + ghEp4);

        %uh^2
        Int2 = (4*g^2*h0^2*t^4*x2 - g*h0*t^2*x2^2*(x2 - 2*t*sqrt(g*h0)) +x2^4/10.0*(2*x2 - 5*t*sqrt(g*h0))) / (4*t^4);
        Int1 = (4*g^2*h0^2*t^4*x1 - g*h0*t^2*x1^2*(x1 - 2*t*sqrt(g*h0)) +x1^4/10.0*(2*x1 - 5*t*sqrt(g*h0))) / (4*t^4);
        u2hEp2 =  (2.0/3.0)^2*(4/(9*g))*(Int2 - Int1);
        uhEp3 = u2^2*h2*(x3 - x2);

        uh = u2hEp2+uhEp3;
        DBE = (gh + uh)/2;
    end
end
