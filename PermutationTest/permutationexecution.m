%This code is executing the Permutations and saves the files. To run this
%code, run matrixforpermutationtestfinal.m before

n = 60; % trials
d = 360; % different features

method='';
Slopes=[];Slope=[];
R=x1(:,1);
Ratings=R(~isnan(R));


%Rating1and2
for q=1:360
R=X1(:,q);
Ratings=R(~isnan(R));
F=C1(:,q);
Features=F(~isnan(F));
[Slope,cvb,XX,bb] = perm(Ratings,Features,NumPerms);
Slopes(:,q)=Slope;
end

%AllRatings
Slopesall=[];R=[];
for q=1:180
R=x3(:,q);
Ratings=R(~isnan(R));
F=column3(:,q);
Features=F(~isnan(F));
[Slopeall,cvb,XX,bb] = perm(Ratings,Features,NumPerms);
Slopesall(:,q)=Slopeall;
end

save(strcat(subject,num2str(condition),method,'SlopesfromPermutation_',num2str(NumPerms)),'Slopes','Slopesall','-v7.3')


%pVals = mean(abs(Slopes) >= abs(Slopes(1,:)),1);

