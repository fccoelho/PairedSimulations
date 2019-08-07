function [Chi2 DZcontrol DZtreat]= F_Chi2Goodness(Zwithout,Zwith,D1,Lmin,Max);
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
% Kolmogorov    Kullback-Leibler Divergence

[ND NR]=size(Zwithout); % typically ND=120 days, NR=130 sets simus

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
    
    DiffsB=(DZcontrol(1:NT,1)-DZtreat(1:NT,1)).*(DZcontrol(1:NT,1)-DZtreat(1:NT,1));
    DiffsB=DiffsB./DZcontrol(1:NT,1);
    Chi2(3,1)=sum(DiffsB);
    Chi2(4,1)=length(DiffsB);


        
    






