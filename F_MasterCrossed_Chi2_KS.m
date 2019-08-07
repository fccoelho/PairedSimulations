function [Chi2 KS]= F_MasterCrossed_Chi2_KS(SetA,SetC,D1,Lmin,Max);
% 
%   Computes the Chi2 Goodness of Fit & Kolmogoric-Smirnov statistics
%   for every combination of Zwith x Zwithout
%
% INPUT
% Zwithout  First Input array, Reference distribution (without treatment)
% Zwith     Second Input array, Experimental with treatment
% D1        First date to consider
% Lmin      Minimum number of days
% Max       Maximum number of cases (population)
%
% OUTPUT
% Chi2      Chi2
% KS        Kolmogorov-Smirnov

[ND NR]=size(SetA); % typically ND=120 days, NR=160 sets simus

Chi2=zeros(NR,NR);
KS=zeros(NR,NR);

for i=1:NR
    for j=1:NR
        Zwithout=SetA(:,i);
        Zwith=SetC(:,j);
        CC= F_Chi2Goodness(Zwithout,Zwith,D1,Lmin,Max);
        KK= F_KolmogorovS(Zwithout,Zwith,D1,Max);
        Chi2(i,j)=CC(3,1);
        KS(i,j)=KK;
    end
end




