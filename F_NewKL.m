function [NewKL DZtreat DZcontrol]= F_NewKL(Zwithout,Zwith,D1,Lmin,Max);
% 
%   Computes the Kullback-Leibler Divergence statistic 
%   Programme assumes that ZP & ZQ are same length vectors giving the
%   cumulative number of cases each day up to ND days
%   Values must be positive
%
% INPUT
% Zout     First Input array, Reference distribution (without treatment)
% Zwith    Second Input array, Experimental with treatment
% D1        First date to consider
% Lmin      Min length time step>0
% Max       Maximum number of cases (population)
%
% OUTPUT
% NewKL    Kullback-Leibler Divergence

[ND NR]=size(Zwithout); % typically ND=120 days, NR=130 sets simus

NewKL=0;
DZcontrol=[];
DZtreat=[];
kk=0;
FP=D1;LP=FP+Lmin;

%Case i=1
i=1;
while(kk==0)
    DZc=Zwith(LP,1)-Zwith(FP,1); %c=control
    DZt=Zwithout(LP,1)-Zwithout(FP,1); % t=treatment
    if((DZc>0)&(DZt>0))
        DZcontrol=DZc;
        DZtreat=DZt;
        kk=1;
        FP=LP;LP=FP+Lmin;
    else
        LP=LP+1;
        kk=0;
    end
    [FP LP];
end

%Case i>1 
kk=0;
for i=2:(ND-1)
    
    while(LP<=ND)
        DZt=Zwith(LP,1)-Zwith(FP,1); % t=treatment 
        DZc=Zwithout(LP,1)-Zwithout(FP,1); %c=control
        %[i FP LP DZt DZc]
        if((DZc>0)&(DZt>0))
            DZcontrol=[DZcontrol;DZc];
            DZtreat=[DZtreat;DZt];
            kk=1;
            FP=LP;LP=FP+Lmin;
            i=i+1;
        else
            LP=LP+1;
            kk=0;
        end
    end
end

% Excluding last class
LL=length(DZcontrol);
LRatio=log(DZcontrol./DZtreat);
LRatioP=LRatio.*DZcontrol/Max;
LRatioQ=(-LRatio.*DZtreat/Max);

NewKL(7,1)=sum(LRatioP);
NewKL(8,1)=LL;

beta=Max;alpha=3;
P=exp(-LL*NewKL(7,1)*NewKL(7,1)/(log(beta/alpha)));
NewKL(9,1)=P;
NewKL(10,1)=sum(LRatioQ);
NewKL(11,1)=LL;
Q=exp(-LL*NewKL(10,1)*NewKL(10,1)/(log(beta/alpha)));
NewKL(12,1)=Q;


%Including last class
[N1 N2]=size(Zwithout);
DZcontrol=[DZcontrol;(Max-Zwithout(N1,1))];
DZtreat=[DZtreat;(Max-Zwith(N1,1))];

LL1=length(DZcontrol);
LRatio=log(DZcontrol./DZtreat);
LRatioP=LRatio.*DZcontrol/Max;
LRatioQ=(-LRatio.*DZtreat/Max);

NewKL(1,1)=sum(LRatioP);
NewKL(2,1)=LL1;

beta=Max;alpha=3;
P1=exp(-LL1*NewKL(1,1)*NewKL(1,1)/(log(beta/alpha)));
NewKL(3,1)=P1;

NewKL(4,1)=sum(LRatioQ);
NewKL(5,1)=LL1;
Q1=exp(-LL1*NewKL(4,1)*NewKL(4,1)/(log(beta/alpha)));
NewKL(6,1)=Q1;







