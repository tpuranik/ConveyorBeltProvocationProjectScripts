%This script calculates the adjusted pvalue comparing the slopes from the
%permuted values using Bonferroni and False Discovery Rate (Benjamini & Yekutieli)

%Note: this script gives options of data to load that was already done in
%other scripts

subject='';
condition=1; %choose one or 2
numm=1000000;%permutation amount
NUM=360; %Bonferroni multiplier for this project

%Load file containing the slopes from the permuted median values: slopes and slopesall
load("path to median slope values")

Scon=Scon1; %Scon 1 or 2
t=[1,5,10,13,11,18,26,23,42];num=1;number=1;

%Calculating actual slopes: 
%Use Calculation below or load fitobjects:r1fitobject, r1fitobject from closevsfarscatter if saved
r=1;
for channel=1:20
num=1;
for freq=1:9
n=20; gamma=NaN(20,11);gammaplot1=[];xvalues=[];r1=[];r2=[];r11=[];r22=[];
multiplier=t(1,freq);%multiplier number for the frequency
for i=1:11
    gammam1=[];gamp=[];gam=[]; gammam2=[];gammaplot2=[];r1=[];r2=[];r11=[];r22=[];
    r11=endpointR1(:,i);
    r1=r11(~isnan(r11));
    r22=endpointR2(:,i);
    r2=r22(~isnan(r22));
    if isempty(Scon{1,channel}{freq,i})==0
        g1=1;
    M1=Scon{1,channel}{freq,i}(g1:end,:);
    else
        M1=NaN(10,1);
    end
    if isempty(Scon{2,channel}{freq,i})==0
        g1=1;
    M2=Scon{2,channel}{freq,i}(g1:end,:); %for all of the things for that ratings
    M4=Scon{2,channel}{freq,i}(g2:end,:);
    else
        M2=NaN(10,1);
    end
    coun1=1;coun2=2;
     for h=1:1:size(r1,1) %1 and 2 will be rating 1, 3 and 4 are rating2
         gammam1(coun1)=nanmedian(M1(:,h),1);
          coun1=coun1+1;
     end
     coun1=1;coun2=1;
     for h=1:1:size(r2,1) %1 and 2 will be rating 1, 3 and 4 are rating2
          gammam2(coun1)=nanmedian(M2(:,h),1);
          coun1=coun1+1;
     end
    
    gammam1(gammam1==0)=[];gammam2(gammam2==0)=[];
    if isempty(gammam1)==0 %accounting for empty ones
    gammam1(end+1:n)=NaN;
    gamma(:,i)=gammam1;
    else
        gammam1=NaN(20,1);
        gamma(:,i)=gammam1;        
    end
    if isempty(gammam2)==0 %for rating2
    gammam2(end+1:n)=NaN;
    gamma2(:,i)=gammam2;
    else
        gammam2=NaN(20,1);
        gamma2(:,i)=gammam2;
    end
end
gammaplot1=reshape(gamma,[],1);
gammaplot2=reshape(gamma2,[],1);

gammaplot=[gammaplot1];
gammaplotT=[gammaplot2];
xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];
x=[xvalues;xvalues];

mask=isnan(gammaplot);
x_t=x(~mask);
gamma_t=gammaplot(~mask);
gammar=gamma_t;
fitobject(number,:)=polyfit(x_t,gammar,1);

mask2=isnan(gammaplotT);
x_t2=x(~mask2);
gamma_t2=gammaplotT(~mask2);
fitobject2(number,:)=polyfit(x_t2,gamma_t2,1);

xx=1:11;
slopeactual1(channel,freq)=fitobject(number,1);
slopeactual2(channel,freq)=fitobject2(number,1);
num=num+1;
number=number+1;
end
end

%Calculating slope actual for all
t=[1,5,10,13,11,18,26,23,42];num=1;number=1;
for channel=1:20
num=1;
for freq=1:9
n=20; gamma=NaN(20,11);gammaplot1=[];xvalues=[];
multiplier=t(1,freq);%multiplier number for the frequency
for i=1:11
    gammam1=[];gamp=[];gam=[]; gammam2=[];gammaplot2=[];
    if isempty(Scon{1,channel}{freq,i})==0
        M1=Scon{1,channel}{freq,i}(1:end,:);
    else
        M1=NaN(10,1);
    end
    if isempty(Scon{2,channel}{freq,i})==0
        M2=Scon{2,channel}{freq,i}(1:end,:);
    else
        M2=NaN(10,1);
    end
    gammam1=nanmedian(M1,1);
    gammam2=nanmedian(M2,1);
    gammam1(gammam1==0)=[];gammam2(gammam2==0)=[];
    if isempty(gammam1)==0 %accounting for empty ones
    gammam1(end+1:n)=NaN;
    gamma(:,i)=gammam1;
    else
        gammam1=NaN(20,1);
        gamma(:,i)=gammam1;
    end
    if isempty(gammam2)==0 %for rating2
        gammam2(end+1:n)=NaN;
        gamma2(:,i)=gammam2;
    else
        gammam2=NaN(20,1);
        gamma2(:,i)=gammam2;
    end
end
gammaplot1=reshape(gamma,[],1);
gammaplot2=reshape(gamma2,[],1);

gammaplot=[gammaplot1;gammaplot2];
xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];
x=[xvalues;xvalues];

mask=isnan(gammaplot);
x_t=x(~mask);
gamma_t=gammaplot(~mask);
gammar=gamma_t;
fitobject(number,:)=polyfit(x_t,gammar,1);%gamma_t,1);
xx=1:11;
slopeactual(channel,freq)=fitobject(number,1);

xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];
num=num+1;
number=number+1;
end
%saveas(gcf,strcat(subject,method,channel,'.png'),'.png');

end


%Calculating pvalues and adjusted pvalues using Bonferroni Correction
M=[];channel4=[];channel5=[];channel6=[];
coun=1;
[channel4]= calcp(slopeactual1,Slopes,coun)
adjustedp4=channel4*NUM;
[h4, crit_p4, adj_ci_cvrg4, adj_p4]=fdr_bh(channel4,0.05,'dep','no');

%For Rating2
[channel5]= calcp(slopeactual2,Slopes,180)
adjustedp5=channel5*NUM;
[h5, crit_p5, adj_ci_cvrg5, adj_p5]=fdr_bh(channel5,0.05,'dep','no');

%For all
[channel6]= calcp(slopeactual,Slopesall,1)
adjustedp6=channel6*NUM;
[h6, crit_p6, adj_ci_cvrg6, adj_p6]=fdr_bh(channel6,0.05,'dep','no');

%saving values
save(strcat(subject,'fdrandbonferroni',num2str(NUM),'_adjustedpvalues.mat'),'adjustedp4','adjustedp5','adjustedp6','adj_p4','adj_p5','adj_p6')

%-------PLOTTING------------
method=num2str(NUM); %correction factor amount 
%For All Rating
figure()
sgtitle(strcat(subject,'condition',condition,num2str(condition),method,' Perm',num2str(NumPerms)))
subplot(1,3,1)
imagesc(adjustedp4,[0 0.06])
title('rating1')
colorbar
subplot(1,3,2)
imagesc(adjustedp5,[0 0.06])
title('rating2')
colorbar
subplot(1,3,3)
imagesc(adjustedp6,[0 0.06])
title('ratingall')
colorbar

%plotting unadjusted to see significance
method='unadjusted p value';
figure()
sgtitle(strcat(subject,'condition',condition,num2str(condition),method,' Perm',num2str(NumPerms)))
subplot(1,3,1)
imagesc(channel4,[0 0.06])
title('rating1')
colorbar
subplot(1,3,2)
imagesc(channel5,[0 0.06])
title('rating2')
colorbar
subplot(1,3,3)
imagesc(channel6,[0 0.06])
title('ratingall')
colorbar

%plotting FDR
method='FDR';
figure()
sgtitle(strcat(subject,'condition',condition,num2str(condition),method,' Perm',num2str(NumPerms)))
subplot(1,3,1)
imagesc(adj_p4,[0 0.055])
xticks([1 2 3 4 5 6 7 8 9]);
yticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]);
yticklabels({'AFZ','C3','C4','CPZ','CZ','F3','F4','F7','F8','FC1','FC2','FC5','FC6','FP1','FP2','FT9','FT10','FZ','T7','T8'});
xticklabels({'delta','theta','alpha1','alpha2','alpha','beta1','beta2','beta','gamma'})
xtickangle(55)
title('rating1')
colorbar
subplot(1,3,2)
imagesc(adj_p5,[0 0.055])
xticks([1 2 3 4 5 6 7 8 9]);
yticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]);
yticklabels({'AFZ','C3','C4','CPZ','CZ','F3','F4','F7','F8','FC1','FC2','FC5','FC6','FP1','FP2','FT9','FT10','FZ','T7','T8'});
xticklabels({'delta','theta','alpha1','alpha2','alpha','beta1','beta2','beta','gamma'})
xtickangle(55)
title('rating2')
colorbar
subplot(1,3,3)
imagesc(adj_p6,[0 0.055])
xticks([1 2 3 4 5 6 7 8 9]);
yticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]);
yticklabels({'AFZ','C3','C4','CPZ','CZ','F3','F4','F7','F8','FC1','FC2','FC5','FC6','FP1','FP2','FT9','FT10','FZ','T7','T8'});
xticklabels({'delta','theta','alpha1','alpha2','alpha','beta1','beta2','beta','gamma'})
xtickangle(55)
title('ratingall')
colorbar
set(gcf,'color','w')

function [h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(pvals,q,method,report)
%https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/27418/versions/9/previews/fdr_bh.m/index.html
if nargin<1,
    error('You need to provide a vector or matrix of p-values.');
else
    if ~isempty(find(pvals<0,1)),
        error('Some p-values are less than 0.');
    elseif ~isempty(find(pvals>1,1)),
        error('Some p-values are greater than 1.');
    end
end
if nargin<2,
    q=.05;
end
if nargin<3,
    method='pdep';
end
if nargin<4,
    report='no';
end
s=size(pvals);
if (length(s)>2) || s(1)>1,
    [p_sorted, sort_ids]=sort(reshape(pvals,1,prod(s)));
else
    %p-values are already a row vector
    [p_sorted, sort_ids]=sort(pvals);
end
[dummy, unsort_ids]=sort(sort_ids); %indexes to return p_sorted to pvals order
m=length(p_sorted); %number of tests
if strcmpi(method,'pdep'),
    %BH procedure for independence or positive dependence
    thresh=(1:m)*q/m;
    wtd_p=m*p_sorted./(1:m);
    
elseif strcmpi(method,'dep')
    %BH procedure for any dependency structure
    denom=m*sum(1./(1:m));
    thresh=(1:m)*q/denom;
    wtd_p=denom*p_sorted./[1:m];
    %Note, it can produce adjusted p-values greater than 1!
    %compute adjusted p-values
else
    error('Argument ''method'' needs to be ''pdep'' or ''dep''.');
end
if nargout>3,
    %compute adjusted p-values; This can be a bit computationally intensive
    adj_p=zeros(1,m)*NaN;
    [wtd_p_sorted, wtd_p_sindex] = sort( wtd_p );
    nextfill = 1;
    for k = 1 : m
        if wtd_p_sindex(k)>=nextfill
            adj_p(nextfill:wtd_p_sindex(k)) = wtd_p_sorted(k);
            nextfill = wtd_p_sindex(k)+1;
            if nextfill>m
                break;
            end;
        end;
    end;
    adj_p=reshape(adj_p(unsort_ids),s);
end
rej=p_sorted<=thresh;
max_id=find(rej,1,'last'); %find greatest significant pvalue
if isempty(max_id),
    crit_p=0;
    h=pvals*0;
    adj_ci_cvrg=NaN;
else
    crit_p=p_sorted(max_id);
    h=pvals<=crit_p;
    adj_ci_cvrg=1-thresh(max_id);
end
if strcmpi(report,'yes'),
    n_sig=sum(p_sorted<=crit_p);
    if n_sig==1,
        fprintf('Out of %d tests, %d is significant using a false discovery rate of %f.\n',m,n_sig,q);
    else
        fprintf('Out of %d tests, %d are significant using a false discovery rate of %f.\n',m,n_sig,q);
    end
    if strcmpi(method,'pdep'),
        fprintf('FDR/FCR procedure used is guaranteed valid for independent or positively dependent tests.\n');
    else
        fprintf('FDR/FCR procedure used is guaranteed valid for independent or dependent tests.\n');
    end
end
end

function [channel4]= calcp(slopeactual1,Slopes,coun)
for ch=1:20
for i=1:1:9
    B=[]; Actual=[]; 
Actual=slopeactual1(ch,i);%number for median of this
if Actual>0
    M=Slopes(:,coun);
    B=find(M>Actual);
    channel4(ch,i)=size(B,1)/(size(M,1)+1);
else
    M=Slopes(:,coun);
    B=find(M<Actual);
    channel4(ch,i)=size(B,1)/(size(M,1)+1);
end
check(coun)=size(B,1);
coun=coun+1;
end
end
end


