function KS= F_KolmogorovS(Zwithout,Zwith,D1,Max);
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
% Max       Maximum number of cases (population)
%
% OUTPUT
% KS        Kolmogorov-Smirnov statistic

[ND NR]=size(Zwithout); % typically ND=120 days, NR=130 sets simus

KS=max(Zwithout-Zwith)/Max;




