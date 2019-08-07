function [StatsA StatsC ResPStack]= F_Master2CasesRepeated(ND,NP,NM,Param,NRep);
% 
%   Initializes arrays People & Mossies from the transport matrices
%   
% INPUT
% ND    Number of Days to be simulated
% NP    Array 10x4 containing number of people in each of 10 key locations
%           at different times of day
% NM    Vector 10x1 containing number of mossies in each of same 10 locations 
% Param Vector of Parameters
% NRep   N° of repetitions
%
% OUTPUT
% 
StatsA=[];StatsC=[];
tic
% No People Live at Centro
for ir=1:NRep
    
    k=(ir-1)*3;
    [ResPA ResMA PR11 PR22 PR34 UU  ]= F_SimulTrains8Dec(ND,NP,NM,Param,[],[],[],[]);
    RecovAFin=ResPA(4,ND*4);
    I90=((ResPA(4,:)>0.9*RecovAFin)).*(1:4*ND);
    Q90=min(I90(I90>0))/4;
    I50=((ResPA(4,:)>0.5*RecovAFin)).*(1:4*ND);
    Q50=min(I50(I50>0))/4;
    I10=((ResPA(4,:)>0.1*RecovAFin)).*(1:4*ND);
    Q10=min(I10(I10>0))/4;
    StatsA=[StatsA [Q10;Q50;Q90;RecovAFin]];
    ResPStack(:,:,k+1)=ResPA;
    
    
    [ResPC ]= F_SimulTrains8DecC(ND,NP,NM,Param,PR11,PR22,PR34,UU);
    RecovCFin=ResPC(4,ND*4);
    I90=((ResPC(4,:)>0.9*RecovCFin)).*(1:4*ND);
    Q90=min(I90(I90>0))/4;
    I50=((ResPC(4,:)>0.5*RecovCFin)).*(1:4*ND);
    Q50=min(I50(I50>0))/4;
    I10=((ResPC(4,:)>0.1*RecovCFin)).*(1:4*ND);
    Q10=min(I10(I10>0))/4;
    StatsC=[StatsC [Q10;Q50;Q90;RecovCFin]];
    ResPStack(:,:,k+2)=ResPC;
end
toc

    





