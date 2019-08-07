function [Chi2Control KSControl]=F_ControlControl(Zwith,Zwithout,D1,Lmin,Max);
% Subroutine to compute Chi2 & KS for pairs, for a control with a control,
% then a treatment with a treatment (randomly selected)
%
% date: 26 July 2019
% Input
% Zwith             typically 120 x 160
% Zwithout
% 
% Output 
% Chi2Control       Array of size NS x 3 for (1) pairs (2) control-control
%                       (3) treatment
% KSControl         Array of size NS x 3 for (1) pairs (2) control-control
%                       (3) treatment


[ND NS]=size(Zwith);    % ND=days NS =simus

Chi2Control=zeros(ND,3);     % Paired, control-control, treatment-treatment
KSControl=zeros(ND,3);

RR=randperm(NS);
for j=1:NS
    ZwithB(:,j)=Zwith(:,RR(j));
    ZwithoutB(:,j)=Zwithout(:,RR(j));
end


for i=1:NS
    ZWAA=Zwith(:,i);ZWBB=ZwithB(:,i);
    ZWOA=Zwithout(:,i);ZWOB=ZwithoutB(:,i);
    AAA= F_Chi2Goodness(ZWAA,ZWOA,D1,Lmin,Max);
    BBB= F_Chi2Goodness(ZWAA,ZWBB,D1,Lmin,Max);
    CCC= F_Chi2Goodness(ZWOA,ZWOB,D1,Lmin,Max);
    Chi2Control(i,1:3)=[AAA(3,1);BBB(3,1);CCC(3,1)];
    
    DDD= F_KolmogorovS(ZWAA,ZWOA,D1,Max);
    EEE= F_KolmogorovS(ZWAA,ZWBB,D1,Max);
    FFF= F_KolmogorovS(ZWOA,ZWOB,D1,Max);
    KSControl(i,1:3)=[DDD;EEE;FFF];
end
    