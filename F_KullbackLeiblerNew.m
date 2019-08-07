function KLNew= F_KullbackLeiblerNew(Zwithout,Zwith,D1,DD,Max);
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
% DD        Blocks of DD days
% Max       Maximum number of cases (population)
%
% OUTPUT
% KL    Kullback-Leibler Divergence

[ND NR]=size(Zwithout); % typically ND=120 days, NR=130 sets simus

NP=floor((ND-D1)/DD);NT=NP;
if(ND-D1-NP*DD>0)
    NT=NP+1;
end


ZZwith=[Zwith(D1:DD:ND,1);Max];
ZZwithout=[Zwithout(D1:DD:ND,1);Max];
NT=size(ZZwith)

ZZZwith=ZZwith(1,1);
ZZZwithout=ZZwithout(1,1);
for i=2:NT
    ZZZwith(i,1)=ZZwith(i,1)-ZZwith(i-1,1);
    ZZZwithout(i,1)=ZZwithout(i,1)-ZZwithout(i-1,1);
end
    
    Ikeep=(ZZZwith>0).*(ZZZwithout>0);          %Keeps nonzero elements
    ZZZwith=ZZZwith(Ikeep==1,1);
    ZZZwithout=ZZZwithout(Ikeep==1,1);
    
LRatio=log(ZZZwithout./ZZZwith);
LRatioP=LRatio.*ZZZwithout/Max;

KLNew(1,1)=sum(LRatioP);
KLNew(2,1)=sum(Ikeep);

        
    






