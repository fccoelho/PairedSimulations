function [People Mossies]= F_Initialize7Dec(ND,NP,NM,N0,D1,D2,D3);
% 
%   Initializes arrays People & Mossies from the transport matrices
%   
% INPUT
% ND    Number of Days to be simulated
% NP    Array 10x4 containing number of people in each of 10 key locations
%           at different times of day
% NM    Vector 10x1 containing number of mossies in each of same 10 locations 
% N0    N° of infected couples  initially
%
% OUTPUT
% People
% Mossies

NPTot=sum(NP);NMTot=sum(NM);
% Station then suburb

% Initialize Matrices: People & Mossies
People=zeros(NPTot(1,1),10+4*ND);
Mossies=zeros(NMTot,5+ND*4); 

% NM mosquitos in each location (except possibly ZonaSul station)
    M1=[1*ones(NM(1),1);2*ones(NM(2),1);3*ones(NM(3),1);4*ones(NM(4),1);5*ones(NM(5),1)];
    M2=[6*ones(NM(6),1);7*ones(NM(7),1);8*ones(NM(8),1);9*ones(NM(9),1);10*ones(NM(10),1)];
    Mossies(:,1)=[M1;M2];
    Mossies(:,2)=ones(NMTot,1); % Initially all are susceptibles
    Mossies(:,3)=zeros(NMTot,1); %Initially none have been exposed
    Mossies(:,4)=(ND+1)*ones(NMTot,1); %Date when first exposed
    Mossies(:,5)= zeros(NMTot,1); % Initially none are infectious
    
%People No people live in Centro NP(7,1)=NP(8,1)=0 

% Mornings
A=[1*ones(NP(1,1),1);2*ones(NP(2,1),1)];% Bangu station then home area
B=[3*ones(NP(3,1),1);4*ones(NP(4,1),1)]; % Campo Grande station then home
C=[5*ones(NP(5,1),1);6*ones(NP(6,1),1)]; %Meier station then home area
D=[7*ones(NP(7,1),1);8*ones(NP(8,1),1)]; %Centro Station then Business area
E=[9*ones(NP(9,1),1);10*ones(NP(10,1),1)]; %ZonaSul Metro Station then area
People(:,1)=[A;B;C;D;E];
% Noontime
A=[8*ones(NP(1,2),1);2*ones(NP(2,2),1)];% Bangu 100 home 100 Bangu station
B=[8*ones(NP(3,2),1);4*ones(NP(4,2),1)]; % Campo Grande 100 home, 100 Centro area
C=[8*ones(NP(5,2),1);6*ones(NP(6,2),1)]; %Meier 100 home 100 centro area
D=[8*ones(NP(7,2),1);8*ones(NP(8,2),1)]; %Centro
E=[8*ones(NP(9,2),1);10*ones(NP(10,2),1)]; %ZonaSul 100 home 100 Centro area
People(:,2)=[A;B;C;D;E];
%Afternoon
A=[7*ones(NP(1,3),1);2*ones(NP(2,3),1)];% Bangu 100 home 200 Centro station
B=[7*ones(NP(3,3),1);4*ones(NP(4,3),1)]; % Campo Grande 100 home, 100 Centro area
C=[7*ones(NP(5,3),1);6*ones(NP(6,3),1)]; %Meier 100 home 100 centro station
D=[7*ones(NP(7,3),1);8*ones(NP(8,3),1)]; %Centro
E=[7*ones(NP(9,3),1);10*ones(NP(10,3),1)]; %ZonaSul 100 home 100 Centro Station
People(:,3)=[A;B;C;D;E];
% Evenings
A=[2*ones(NP(1,4),1);2*ones(NP(2,4),1)];
B=[4*ones(NP(3,4),1);4*ones(NP(4,4),1)];
C=[6*ones(NP(5,4),1);6*ones(NP(6,4),1)];
D=[8*ones(NP(7,4),1);8*ones(NP(8,4),1)];
E=[10*ones(NP(9,4),1);10*ones(NP(10,4),1)];

People(:,4)=[A;B;C;D;E];
People(:,5)=ones(NPTot(1,1),1); % Initially all people are susceptibles
People(:,7)=(ND+1)*ones;    % date of expose set after end of period

%  Put N0 infectious people in Bangu stay in area & N0 Travel to Centro

People(1:N0,8)=ones(N0,1); % Infectious people
People(1:N0,7)=-(D1+1)*ones(N0,1); % D1=time from exposure to infectious
People(1:N0,5)=zeros(N0,1); % Infectious people no longer susceptible

k=NP(1,1);
People(k+1:k+N0,8)=ones(N0,1);
People(k+1:k+N0,7)=-(D1+1)*ones(N0,1);
People(k+1:k+N0,5)=zeros(N0,1);


