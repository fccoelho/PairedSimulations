function [ResP ResM PR11 PR22 PR34 UU People Mossies ]= F_SimulTrains8DecC(ND,NP,NM,Param,PR11,PR22,PR34,UU);
% 
%   Simulates train transport of ZIKV
%   NS stations called CG (Campo Grande) B(Bangu) M(Meier) C(Centro) 
%   & ZC ZonaSul
%   The residents of each RA live in 2 zones close to station & further
%   away (with less risk of being contaminated). Some people remain in RA;
%   others go to work (in Centro)
%   Each morning people get bitten by mosquitoes while waiting on platform
%   for train near residence; each afternoon they get bitten by mosquitoes 
%   while waiting for train to go home. At home they also get bitten by
%   mosquitoes. 
%   Delay1 for mosquito that has bitten infected person to become infectious
%   Delay2 for people bitten infected mosquito to become infectious (&
%   possibly sick)
%   
%   When a mosquito dies it is replaced by another mosquito with the same
%   infectiousness or not
%   
% INPUT
% ND        N0 Days for simulation
% NP        N° People per area
% NM        N° Mossies in each area
% Param     
% PR11      Array of size NPP x (4xND) containing binomial random variables
% PR22      Array of size NPP x (4xND) containing binomial random variables
% PR34      Array of size NMM x (4xND) x 2  containing binomial RVs
% U         Array of size NMM x (4xND) (if NMM <NPP)      
%
% OUTPUT
% ResP      Summary results for people
% ResM      Summary results for Mosquitos
% People    Array giving staus of each person-agent at each time period (4
%           per day)
% Mossies   Array giving staus of mosquito-agents
% 

[pr11 xx]=size(PR11);[pr22 zz]=size(PR22);
[pr34 yy]=size(PR34);
[uu xy]=size(UU);

% Read Parameters
 N0=Param(1,1);
 pr1=Param(2,1);  
 pr2=Param(3,1);
 pr3=Param(4,1);    % Prob vertical transmission for mossies after death
 pr4=Param(5,1);    % Prob mossie dies
 D1=Param(6,1);     % Incubation time before person becomes infectios
 D2=Param(7,1);     % Time for person to recover
 D3=Param(8,1);     % Incubation time before mossie becomes infectious
 maxIL=Param(9,1);
 
% Initialize Matrices: People & Mossies NO MOSSIES ON STATION AT ZC
[People Mossies]=F_Initialize7DecC(ND,NP,NM,N0,D1,D2,D3);
[NPP nn]=size(People);
[NMM mm]= size(Mossies);

if(NMM>NPP)
    [NMM NPP]
end

NXX=min(NMM,NPP);
 
 % read previously generated RVs or generate new ones
 if(pr11<1)
     PR11=binornd(1,pr1,NPP,4*ND);
 end
 if(pr22<1)
    PR22=binornd(1,pr2,NMM,4*ND);
 end
 if(uu<1)
    UU=unifrnd(0,1,NXX,4*ND);
 end
 if(pr34<1)
     PR33=binornd(1,pr3,NMM,ND);
     PR44=binornd(1,pr4,NMM,ND);
     PR34(:,:,1)=PR33;
     PR34(:,:,2)=PR44;
 else
     PR33=PR34(:,:,1);
     PR44=PR34(:,:,2);
 end



% Simulate the interaction between people & mosquitoes during day T
for it=1:ND
    kk=(it-1)*4;
    % Morning noon afternoon evening
    [People2,Mossies2]= F_ContactPersonMossie8Dec(People,Mossies,NP,NM,maxIL,1,it,D1,D2,PR11(:,kk+1),PR22(:,kk+1),UU(:,kk+1));  
    [People3,Mossies3]= F_ContactPersonMossie8Dec(People2,Mossies2,NP,NM,maxIL,2,it,D1,D2,PR11(:,kk+2),PR22(:,kk+2),UU(:,kk+2));
    [People4,Mossies4]= F_ContactPersonMossie8Dec(People3,Mossies3,NP,NM,maxIL,3,it,D1,D2,PR11(:,kk+3),PR22(:,kk+3),UU(:,kk+3));
    [People5,Mossies5]= F_ContactPersonMossie8Dec(People4,Mossies4,NP,NM,maxIL,4,it,D1,D2,PR11(:,kk+4),PR22(:,kk+4),UU(:,kk+4));
    
    People=People5;Mossies=Mossies5;
    % Update daily status 
    %
     jj=(it-1)+1;
     [People,Mossies ]= F_DailyUpdate7Dec(People5,Mossies5,D1,D2,D3,PR33(:,jj),PR44(:,jj),it,ND);
     
     clear People2 People3 People4 People5 Mossies2 Mossies3 Mossies4 Mossies5
end
    LastColP=10+ND*4;
    LastColM=4+ND*4;
    IP1=(People(:,11:LastColP)==1);
    IP2=(People(:,11:LastColP)==2);
    IP3=(People(:,11:LastColP)==3);
    IP4=(People(:,11:LastColP)==4);
    ResP(1,:)=sum(IP1);
    ResP(2,:)=sum(IP2);
    ResP(3,:)=sum(IP3);
    ResP(4,:)=sum(IP4);
    
    IM1=(Mossies(:,5:LastColM)==1);
    IM2=(Mossies(:,5:LastColM)==2);
    IM3=(Mossies(:,5:LastColM)==3);
    ResM(1,:)=sum(IM1);
    ResM(2,:)=sum(IM2);
    ResM(3,:)=sum(IM3);
    ResM(4,:)=sum(ResM);
    PP=People(:,11:LastColP);
    
    for il=1:maxIL
        kk=il*4; 
        
        if(NP(il,1)==0)
            ResP(kk+1:kk+4,:)=zeros(4,4*ND);
        end
        
        IIL=(People(:,1)==il);
        IPP1=(PP(IIL==1,:)==1);
        IPP2=(PP(IIL==1,:)==2);
        IPP3=(PP(IIL==1,:)==3);
        IPP4=(PP(IIL==1,:)==4);
        if(NP(il,1)>1)
            ResP(kk+1,:)=sum(IPP1);
            ResP(kk+2,:)=sum(IPP2);
            ResP(kk+3,:)=sum(IPP3);
            ResP(kk+4,:)=sum(IPP4);
        elseif(NP(il,1)==1)
            ResP(kk+1,:)=IPP1; 
            ResP(kk+2,:)=IPP2;
            ResP(kk+3,:)=IPP3;
            ResP(kk+4,:)=IPP4;
        end
    end

    
    