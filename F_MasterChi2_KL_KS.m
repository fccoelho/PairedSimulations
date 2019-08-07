function [Chi2 KS KL]= F_MasterChi2_KL_KS(Zwithout,Zwith,D1,Lmin,Max);
% 
%   Computes theChi2 Goodness of Fit statistic 
%   Programme assumes that ZP & ZQ are same length vectors giving the
%   cumulative number of cases each day up to ND days
%   Values must be positive
%
% INPUT
% Zwithout  First Input array, Reference distribution (without treatment)
% Zwith     Second Input array, Experimental with treatment
% D1        First date to consider
% Lmin      Minimum number of days
% Max       Maximum number of cases (population)
%
% OUTPUT
% Chi2      Chi2 goodness of fit
% KS        Kolmogorov   
% KL        Kullback-Leibler Divergence

[ND NR]=size(Zwithout); % typically ND=120 days, NR=130 sets simus

KS=max(abs(Zwith-Zwithout))/Max;

i=1;kk=0;FP=D1;LP=FP+Lmin;
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

end
kk=0;
for i=2:(ND-1)
    
    while(LP<=ND)
        DZt=Zwith(LP,1)-Zwith(FP,1); % t=treatment 
        DZc=Zwithout(LP,1)-Zwithout(FP,1); %c=control
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
NT=length(DZcontrol);

% Last Class
DZtreat(NT+1,1)=Max-sum(DZtreat(1:NT,1));
DZcontrol(NT+1,1)=Max-sum(DZcontrol(1:NT,1));
    
    Diffs=(DZcontrol-DZtreat).*(DZcontrol-DZtreat)./DZcontrol;
    Chi2(1,1)=sum(Diffs);
    Chi2(2,1)=length(Diffs);
    LRatio=log(DZcontrol./DZtreat);
    LRatioP=LRatio.*DZcontrol/Max;
    %LRatio=log(DZtreat./DZcontrol);
    %LRatioP=LRatio.*DZtreat/Max;

    KL(1,1)=sum(LRatioP);%Last class included
    LL=length(Diffs);
    KL(2,1)=LL;
    
    %Without last class
    DiffsB=(DZcontrol(1:NT,1)-DZtreat(1:NT,1)).*(DZcontrol(1:NT,1)-DZtreat(1:NT,1));
    DiffsB=DiffsB./DZcontrol(1:NT,1);
    Chi2(3,1)=sum(DiffsB);
    Chi2(4,1)=length(DiffsB);
    
    LRatioB=log(DZcontrol(1:NT,1)./DZtreat(1:NT,1));
    LRatioPB=LRatioB.*DZcontrol(1:NT,1)/Max;
    %LRatioB=log(DZtreat(1:NT,1)./DZcontrol(1:NT,1));
    %LRatioPB=LRatioB.*DZtreat(1:NT,1)/Max;

    KL(3,1)=sum(LRatioPB);
    LLB=length(DiffsB);
    KL(4,1)=LLB;
    
    beta=Max;alpha=3;
    P=exp(-LL*KL(1,1)*KL(1,1)/(log(beta/alpha)));
    PB=exp(-LLB*KL(3,1)*KL(3,1)/(log(beta/alpha)));
    KL(5,1)=P;  %Prob with last class
    KL(6,1)=PB; % Prob without last class
    
    

    
    






