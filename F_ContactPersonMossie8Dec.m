function [People2,Mossies2 ]= F_ContactPersonMossie7Dec(People,Mossies,NP,NM,maxIL,TDay,T,D1,D2,PR1,PR2,U);
% 
%   Simulates contact when mosquitoes bite people at location IL1 
%   
%   
% INPUT
% People    Matrix of size (NP x (10+4xND))
% Mossies   Matrix of size (NM x (5+4xND))
% maxIL     Maximum number of locations
% TDay      1,2,3,4 for morning Noon afternoon, evening
% T         Time (Day-1)*4 + TDay 
% D1        No of days those exposed before becoming infected
% D2        No of days those infected before recovering
% PR1        Prob that a mosquito that bites an infectious person gets virus
% PR2        Prob that a person bitten by an infected mosquito gets virus
% U         Uniform rand V for rand permutation
% 
%
% OUTPUT
% D

[NP nn]=size(People);ND=(nn-10)/4;
[NM mm]=size(Mossies);

% At time TDay in T, current position on People file=10+TDay+(T-1)*3
    PCol=10+TDay+(T-1)*4;
    MCol=5+TDay+(T-1)*4;
% At time TDay in T, current position in Mossies file=4+TDay+(T-1)*3
% if T>1,copy status at previous status into current position

ku=0;
for il=1:maxIL
    
    % n° of people (& of mossies) currently at location il 
    IPL=(People(:,TDay)==il);NPL=sum(IPL);
    IP=[IPL (1:NP)']; %  Length NP x 2 columns
    IP2=IP(IPL==1,:); %Length NPL x 2 columns
    IP3=[(1:NPL)' IP2]; % length NPL x 3 columns
    IML=(Mossies(:,1)==il);NML=sum(IML);
    IM=[IML (1:NM)'];% Length NM x 2 columns
    IM2=IM(IML==1,:); % Length NML x 2 columns
    IM3=[(1:NML)' IM2]; % Length NML x 3 columns
    
    %[T TDay il NPL NML]

    if(NPL>=NML)
        %Select NML people at random, update persons status if necessary
        %PToBite=sortrows([ceil(unifrnd(0,1,NML,1)*NPL) (1:NML)']); 
        PToBite=sortrows([ceil(U(ku+1:ku+NML,1)*NPL) (1:NML)']);
        Y=zeros(NP,1);Z=zeros(NP,1);
       %If mossie is infectious & person is susceptible then person's
       %status is updated to bitten, not otherwise
       %If mossie is susceptible & person is infectious then mossie's
       %status is updated to bitten, not otherwise
        
       ku=ku+NML;
       for kk=1:NML
            p1=PToBite(kk,1); % rank out of NPL
            q1=PToBite(kk,2); %rank out of NML
            p2=IP3(p1,3);  % rank out of NP
            q2=IM3(q1,3); % rank out of NM
             %[kk p2 q2] 
            Z=People(p2,5)*Mossies(q2,5).*PR2(q2,1); % mossie infects person
            People(p2,5:7)=People(p2,5:7)*(Z==0)+[0 1 T]*(Z==1);
           
            Y=People(p2,8)*Mossies(q2,2)*PR1(p2,1); %person contaminates mossie
            Mossies(q2,2:4)=Mossies(q2,2:4)*(Y==0)+[0 1 T]*(Y==1);
        end      
          
    elseif((NPL<NML)&(NPL>0))
            MBiter=sortrows([ceil(unifrnd(0,1,NPL,1)*NML) (1:NPL)']); 
            Z=zeros(NM,1);Y=zeros(NM,1);
       %If mossie is infectious & person is susceptible then person's
       %status is updated to bitten, not otherwise
       %If mossie is susceptible & person is infectious then mossie's
       %status is updated to bitten, not otherwise
        for kk=1:NPL
            p1=MBiter(kk,1); % rank out of NPL
            q1=MBiter(kk,2); %rank out of NML
            p2=IP3(p1,3);  % rank out of NP
            q2=IM3(q1,3); % rank out of NM
            Z=People(p2,5)*Mossies(q2,5); % mossie infects person
            People(p2,5:7)=People(p2,5:7)*(Z==0)+[0 1 T]*(Z==1);
            Y=People(p2,8)*Mossies(q2,2); %person contaminates mossie
            Mossies(q2,2:4)=Mossies(q2,2:4)*(Y==0)+[0 1 T]*(Y==1);
        end      
    end
end
       
    MCol=5+(T-1)*4+TDay;
    PCol=10+(T-1)*4+TDay;
    
    People(:,PCol)=1*People(:,5)+2*People(:,6)+3*People(:,8)+4*People(:,9);
    Mossies(:,MCol)=1*Mossies(:,2)+2*Mossies(:,3)+3*Mossies(:,5);
    if(min(Mossies(:,MCol))==0)
        IR=(Mossies(:,MCol)==0);NIR=IR.*(1:NM)';NIR=NIR(NIR>0);
        [il NIR']
    end
        
People2=People;
Mossies2=Mossies;

