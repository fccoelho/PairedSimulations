function [CurveStatswith CurveStatswithout]=F_AvCurves(Zwith,Zwithout);
% Subroutine to compute mean & quantiles of cumulative curves of cases
%
% date: 21 July 2019
% Input
% Zwith             typically 120 x 160
% Zwithout
% 
% Output 
% CurveStatswith        Average, then Q10 & Q90 
% CurveStatswithout

[ND NS]=size(Zwith);    % ND=days NS =simus

CurvesWith=zeros(ND,3);     % Average, Q10 then Q90
CurvesWithout=zeros(ND,3);

for i=1:120
    XWith=Zwith(i,:);
    AvX=mean(XWith);
    Q10=prctile(XWith,10);
    Q90=prctile(XWith,90);
    CurveStatswith(i,:)=[AvX Q10 Q90];
    
    XWithout=Zwithout(i,:);
    AvX=mean(XWithout);
    Q10=prctile(XWithout,10);
    Q90=prctile(XWithout,90);
    CurveStatswithout(i,:)=[AvX Q10 Q90];
end
    