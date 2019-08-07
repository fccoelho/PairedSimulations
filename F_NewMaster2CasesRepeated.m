function [ResPStack StorePR11 StorePR22 StorePR34 StoreUU]= F_NewMaster2CasesRepeated(ND,NP,NM,Param,NRep);
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

%Date 18Feb 2019
tic

for ir=1:NRep
    k=(ir-1)*2; %CHANGED INDEXING HERE
    [ResPA ResMA PR11 PR22 PR34 UU  ]= F_SimulTrains8Dec(ND,NP,NM,Param,[],[],[],[]); 
    ResPStack(:,:,k+1)=ResPA; 
    ir
    if(ir==1)

         StorePR11=PR11;
         StorePR22=PR22;
         StorePR34=PR34;
         StoreUU=UU;
    else
        StorePR11=[StorePR11;PR11];
        StorePR22=[StorePR22;PR22];
        StorePR34=[StorePR34;PR34];
        StoreUU=[StoreUU;UU];
    end
    
    [ResPC ]= F_SimulTrains8DecC(ND,NP,NM,Param,PR11,PR22,PR34,UU);
    ResPStack(:,:,k+2)=ResPC;

end
toc

    





