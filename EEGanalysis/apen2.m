%One method of calculating approximate entropy

load('Scon table')
freq=; %frequency band (delta=1, theta=2...)
chan=; %channel number, ex: 16
Scon=; %Scon1 or Scon2

figure()
for chan=1:20
for j=1:11
dim=2; %chosen based on literature
series=[];serie=Scon{1,chan}{freq,j}(:,1);
series=serie(~isnan(serie));
r=std(series)*1.5;
x(chan,j) = ApEn(dim,r,series,1);
end
end
for i=1:1:size(x,1)
    plot(x(i,:),'LineWidth',1)
    hold on;
end
set(gcf,'color','w');
set(gca,'linewidth',2)
set(gca,'FontWeight','bold')
xlabel('Rating')
ylabel('Entropy');
legend('AFZ','C3','C4','CPZ','CZ','F3','F4','F7','F8','FC1','FC2','FC5','FC6','FP1','FP2','FT9','FT10','FZ','T7','T8')


function apen = ApEn( dim, r, data, tau )
%https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/32427/versions/2/previews/ApEn.m/index.html
%ApEn
%   dim : embedded dimension
%   r : tolerance (typically 0.2 * std)
%   data : time-series data
%   tau : delay time for downsampling
%   Changes in version 1
%       Ver 0 had a minor error in the final step of calculating ApEn
%       because it took logarithm after summation of phi's.
%       In Ver 1, I restored the definition according to original paper's
%       definition, to be consistent with most of the work in the
%       literature. Note that this definition won't work for Sample
%       Entropy which doesn't count self-matching case, because the count 
%       can be zero and logarithm can fail.
%
%       A new parameter tau is added in the input argument list, so the users
%       can apply ApEn on downsampled data by skipping by tau. 
%---------------------------------------------------------------------
% coded by Kijoon Lee,  kjlee@ntu.edu.sg
% Ver 0 : Aug 4th, 2011
% Ver 1 : Mar 21st, 2012
%---------------------------------------------------------------------
if nargin < 4, tau = 1; end
if tau > 1, data = downsample(data, tau); end
    
N = length(data);
result = zeros(1,2);
for j = 1:2
    m = dim+j-1;
    phi = zeros(1,N-m+1);
    dataMat = zeros(m,N-m+1);
    
    % setting up data matrix
    for i = 1:m
        dataMat(i,:) = data(i:N-m+i);
    end
    
    % counting similar patterns using distance calculation
    for i = 1:N-m+1
        tempMat = abs(dataMat - repmat(dataMat(:,i),1,N-m+1));
        boolMat = any( (tempMat > r),1);
        phi(i) = sum(~boolMat)/(N-m+1);
    end
    
    % summing over the counts
    result(j) = sum(log(phi))/(N-m+1);
end
apen = result(1)-result(2);
end
