function [GG0 Res]= F_SimuCumCurves(DiffS,Corr,MeanDiff,StDevDiff,NSimu);
% 
%   Simulates the gaussian equivalents of standardized differences
%       DiffS = (Diff_meanDiff)/StDevDiff
%       where Diff=(NewCaseA_9ef - NewCaseC_9ef)
%
% INPUT
% Diff          usually 113 x 100 (for Set100)
% Corr          Matrix of correlation coefficients
% MeanDiff      Column vector 113 x 1
% StDevDiff     Column Vector 113 x 1
% NSimu         No Simulations to generate
%
% OUTPUT
% Res           Matrix of size 120 x NSimu

[ND NS]= size(Diff); %ND =No Days, NS = No simulations
Row1=8;

Res=zeros(ND,NSimu); %First 7rows are empty
GG0=zeros(ND-Row1,NSimu); 
% Diff(NRow,Row1) for whole of row Row1
GG0(1,:)=normrnd(0,1,1,NSimu);
% Row1+1: (1-rho*rho)*Diff(NRow,Row1) + 
for i=1:112
rho12=Corr(i+1,i);
GG0(i+1,:)=rho12*GG0(i,:)+sqrt(1-rho12*rho12)*normrnd(0,1,1,NSimu);
end
Res=GG0.*repmat(StDevDiff,1,NSimu)+repmat(MeanDiff,1,NSimu);
        