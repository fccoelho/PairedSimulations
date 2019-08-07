function [People,Mossies ]= F_DailyUpdate7Dec(People,Mossies,D1,D2,D3,PR3,PR4,T,ND);
% 
%   Updates the status of files People & Mossies as
%   1. Person bitten become infectious after D1 days
%   2   Person who has been infectious for D2 days recovers & is no longer
%       infectious
%   
% INPUT
% People
% Mossies
% D1    Person bitten become infectious after D1 days
% D2    After being infectious for D2 days person recovers & is no longer
%       infectious
% D3    Incubation period before mossies become infectious
% PR3   Prob vertical transmission between mossies array NMM x 1
% PR4   Prob mossie dies array NMM x 1
%
% OUTPUT
% People    Updated file
% Mossies   Updated file

[NPP nn]=size(People);
[NMM mm]=size(Mossies);

% Person becomes infectious D1 days after being exposed ie if T>=D1+Date
    DT=D1+People(:,7);
    InF=(DT==T);
    People(:,6)=(InF==0).*People(:,6)+(InF==1).*zeros(NPP,1); % Person no longer exposed
    People(:,8)=(InF==0).*People(:,8)+(InF==1).*ones(NPP,1); %Person infectious

% Person recovers after D2 days becoming infectious, ie D1+D2 after being exposed 
    DT2=D1+D2+People(:,7);
    IRec=(DT2==T);
    People(:,8)=(IRec==0).*People(:,8)+(IRec==1).*zeros(NPP,1);
    People(:,9)=(IRec==0).*People(:,9)+(IRec==1).*ones(NPP,1);
    
% Mossie becomes infectious D3 days after being exposed
    DTM=D3+Mossies(:,4);
    InFM=(DTM==T);
    Mossies(:,2)=(InFM==0).*Mossies(:,2)+(InFM==1).*zeros(NMM,1); %Mossie not susceptible
    Mossies(:,3)=(InFM==0).*Mossies(:,3)+(InFM==1).*zeros(NMM,1); %Mossie no longer exposed
    Mossies(:,5)=(InFM==0).*Mossies(:,5)+(InFM==1).*ones(NMM,1);
       
% Mosquito dies with prob pr4
% It is replaced by new susceptible mossie 
    IMDead=PR4;IMAlive=ones(NMM,1)-IMDead;  
    Mossies(:,2)=Mossies(:,2).*IMAlive+ones(NMM,1).*IMDead;
    Mossies(:,3)=Mossies(:,3).*IMAlive+zeros(NMM,1).*IMDead;
    Mossies(:,5)=Mossies(:,5).*IMAlive+zeros(NMM,1).*IMDead;
                    
 
    


    


