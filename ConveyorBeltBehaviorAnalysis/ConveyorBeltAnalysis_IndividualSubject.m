
%%Analysis for a single patient's ratings and timings during the Conveyor
%%Belt Provocation Task and visualization of data.

%To use the script, two things need to be changed. 
%1. Change Subject Name
%2. Uncomment the Saveas command if you want to save the figures as photos
%automatically

Subject='';
obj=["Object1";"Object2"; "Object3"];

%Loading conveyor_behavior data
file='';%path to conveyor_behavior table from rotary coder analysis
load(file);
T1table=conveyor_behavior;

%-------------------Initial Plots----------------------------------------
%Plot either Rating 1 versus Rating 2 or Close versus Far
M=[];h=[];

%Rating 1 versus Rating 2 by object M matrix
M(:,1)=conveyor_behavior(1:13,3);
M(:,2)=conveyor_behavior(1:13,4);
M(:,3)=conveyor_behavior(14:26,3);
M(:,4)=conveyor_behavior(14:26,4);
M(:,5)=conveyor_behavior(27:39,3);
M(:,6)=conveyor_behavior(27:39,4);

% Close versus far M matrix
% M(:,1)=[conveyor_behavior(1,3);conveyor_behavior(3,3);conveyor_behavior(1,4);conveyor_behavior(3,4)];
% M(:,2)=[conveyor_behavior(13,3);conveyor_behavior(11,3);conveyor_behavior(11,4);conveyor_behavior(13,4)];
% M(:,3)=[conveyor_behavior(14,3);conveyor_behavior(16,3);conveyor_behavior(14,4);conveyor_behavior(16,4)];
% M(:,4)=[conveyor_behavior(24,3);conveyor_behavior(26,3);conveyor_behavior(24,4);conveyor_behavior(26,4)];
% M(:,5)=[conveyor_behavior(27,3);conveyor_behavior(29,3);conveyor_behavior(27,4);conveyor_behavior(29,4)];
% M(:,6)=[conveyor_behavior(39,3);conveyor_behavior(37,3);conveyor_behavior(37,4);conveyor_behavior(39,4)];

for i=1:6
X(:,i)=mean(M(:,i));
end
[x,h]=ttest2(M(:,1),M(:,2));
[x2,h2]=ttest2(M(:,3),M(:,4));
[x3,h3]=ttest2(M(:,5),M(:,6));
stats(:,1)=[x,x2,x3];
stats(:,2)=[h,h2,h3];

figure();
h=boxplot(M)
set(h,{'linew'},{2})
set(gcf,'color','w');
set(gca,'linewidth',1)
set(gca,'FontWeight','bold')
ylim([0 10])
%xticklabels({'P1 Far','P1 Close','NP Far','NP Close','P2 Far','P2 Close'})
xticklabels({'P1 R1','P1 R2','NP R1','NP R2','P2 R1','P2 R2'})
yticks([ 0 1 2 3 4 5 6 7 8 9 10])
xlabel('Subject and Object Type')
ylabel('Rating')
title(Subject)
h=[];M=[];

%%%------------2.Per Object plotting-----------------------------
%Looking at Rating 1 and Rating 2 individually, loops through each object

%%Initializing Variables/Counters
m=1;u=1;t=1;g=1;r=1;d=1;%start of object1
z=13;%end of object1 time
I=[];y1=[];b=[];x1=[];f=[];
I=[T1table(d:z,2); T1table(d:z,2)];
objects=3;
cc=1;Slopes=zeros(14,2);
mm=[];nn=[];avg=[];
%figures 1-3
for (h=1:1:objects)

%1.Initializing Arrays Per Object
T=[T1table(d:z,3), T1table(d:z,4)]; %Rating 1 and Rating 2 in one array
MM=[T1table(d:z,3); T1table(d:z,4)];

%2.finding R^2 for both Rating one and Rating 2
for(i=1:1:2) 
I1=I;
y1=[T(1:13,u); T(1:13,u+1)];
mdl=fitlm(I1,y1);
b=mdl.Rsquared.Ordinary;
end

%3. 
y=[T(1:13,u); T(1:13,u+1)];
f=polyfit(I,y,1);
x1=I;
y1=polyval(f,I);
eq=strcat(num2str(f(1)),'x +',num2str(f(2)));

n=figure(t)
scatter(T1table(1:13,2),T(1:13,u));
hold on;
scatter(T1table(1:13,2),T(1:13,u+1));

hold on;

plot(x1,y1)
hold on;
legend('Rating Immediately after Object Movement (1)','Rating 20 seconds after Object Movement (2)', strcat(eq,", ",strcat("R^2=",num2str(b))),'Location','northwest');
title(strcat(Subject,obj(g)));
xlabel('Position of Object on Conveyor Belt');
ylabel('Rating');
axis([0 1 0 10])
set(gcf,'color','w');
xticklabels({'1','0.75','0.5','0.25','0'});
set(gca,'XLim',[0 1],'XTick',[0:0.25:1])
hold off;
%4.To uncomment: if want to save automatically
%saveas(n,strcat(strcat(subj,obj(g)),'.png'))
Slopes(cc,1:2)=f;
cc=cc+1;
g=g+1;
r=r+1;
t=t+1;
d=d+13;
z=z+13;
end


%%------------3. All Objects and Trendlines-----------------------
%figure 4: looking at all objects and trendlines on same plot
z=13;
a1=1;a2=13;a3=14;a4=26;a5=27;a6=39;
T=[T1table(a1:a2,3), T1table(a1:a2,4),T1table(a3:a4,3), T1table(a3:a4,4),T1table(a5:a6,3), T1table(a5:a6,4)];
u=1;z=13;t=1;g=1;r=1;
I=T1table(1:z,2);
obj=[1,1,2,2,3,3];
rat=[1,2,1,2,1,2];
x1=[];f=[];
y1=[];
for(i=1:1:6)
I1=I;
y1=[T(1:z,u)];
mdl=fitlm(I1,y1);
b(i)=mdl.Rsquared.Ordinary;
u=u+1;
end
u=1;
xx=[0;0.25;0;0.25;0.5;0.25;0.5;0.75;0.5;0.75;1;0.75;1];
x1=[xx,xx,xx,xx,xx,xx];

for(i=1:1:6)
y=[T(1:z,u)];
f(r,:)=polyfit(I,y,1);
I=x1(:,r);
y1(:,r)=polyval(f(r,:),I);
%Slopes(cc:cc+1,1:2)=f;
t=t+1;
u=u+1;
r=r+1;

%cc=cc+2;
end
Slopes(cc:cc+5,1:2)=f;
cc=cc+6;
figure()
for(i=1:1:6)
    if i==4 || i==3
plot(x1(:,i),y1(:,i),'b','LineWidth',2);
hold on;
    else
 plot(x1(:,i),y1(:,i),'r','LineWidth',2);

hold on;
    end
end
hold on;
for(i=1:1:6)
    if i==4 || i==3
scatter(x1(:,i),T(:,i),[],'b');
hold on;
    else
 scatter(x1(:,i),T(:,i),[],'r');

hold on;
    end
end

for(i=1:1:6) 
    plot(x1(:,i),y1(:,i),'LineWidth',2);
hold on;
end
for i=1:1:6
scatter(x1(:,i),T(:,i));
hold on;
end
title(Subject)
ob=[1,2,1,2,1,2];
o=[1,1,2,2,3,3];

for i=1:1:6
a(i)=strcat("Object", num2str(o(i)),", Rating",num2str(ob(i)), ", R^2=",num2str(b(i)));
end
legend(a(1),a(2),a(3),a(4),a(5),a(6),'Location','northwest');
set(gca,'XLim',[0 1],'XTick',[0:0.25:1])
ylim([0 10])
tx=xlabel('Position of Object on Conveyor Belt');
ty=ylabel('Rating');
ty.FontSize=13;
tx.FontSize=13;
set(gcf,'color','w');
yticklabels({'1','2','3','4','5','6','7','8','9','10'});
xticklabels({'1','2','3','4','5'});
set(gca,'linewidth',1)
set(gca,'FontWeight','bold')

%%%----4. subtracting starting values, looking purely at trends----------
q=figure(5) %FIGURE 5

for(i=1:1:6)
 y2(:,i)=y1(:,i)-f(i,2);
plot(x1(:,i),y2(:,i),'LineWidth',2);
hold on;
end

title(Subject)
xlabel('Position of Object on Conveyor Belt');
ylabel('Rating');
axis([0 1 0 10])
annotation('textbox',[.9 .5 .1 .2],'String','1 is where the Patient is sitting','EdgeColor','none')
ob=[1,2,1,2,1,2];
o=[1,1,2,2,3,3];
for(i=1:1:6)
a(i)=strcat("Object", num2str(o(i)),", Rating",num2str(ob(i)), ", R^2=",num2str(b(i)));
end

legend(a(1),a(2),a(3),a(4),a(5),a(6),'Location','northwest');

axis([0 1 0 10])
set(gca,'XLim',[0 1],'XTick',[0:0.25:1])
xticklabels({'1','0.75','0.5','0.25','0'});
%saveas(q,strcat(subj,'All Objects Normalized','.png'))


%%%----------------------5. Normalized values-----------------------
n=figure(6) %FIGURE 6
T2=normalize(T);
for(i=1:1:6)
scatter(T1table(1:13,2),T2(:,i));
hold on;
end
xlabel('Position of Object on Conveyor Belt');
ylabel('Rating Normalized');
title('Normalized values of all 3 objects')
legend('Object 1 Rating 1', 'Object 1 Rating 2','Object 2 Rating 1','Object 2 Rating 2','Object 3 Rating 1','Object 3 Rating 2');

%%--------7.By point stopped normalized

o1=1;o2=1;o3=1;o4=1;o5=1;c=1;T2=T;
for i=1:1:6
    
for j=1:1:13
    if x1(j,1)==0
        B1(o1,1)=T2(j,i);
        o1=o1+1;
    elseif x1(j,1)==0.25
        B2(o2,1)=T2(j,i);
        o2=o2+1;
    elseif x1(j,1)==0.5
        B3(o3,1)=T2(j,i);
        o3=o3+1;
     elseif x1(j,1)==0.75
        B4(o4,1)=T2(j,i);
        o4=o4+1;
    elseif x1(j,1)==1
        B5(o5,1)=T2(j,i);
        o5=o5+1;
    end
end

end

for number=1:3

ss=12;
sss=18;

    B=[];
    B=B1(1:ss,:);
    i=1;
    x2=[];f=[];y3=[];l=size(B,1)/3;
    BB=B1(l*c-l+1:l*c);
    x2=[l*c-l+1:l*c];
    x2=x2';
    x3=x2;
    f(i,:)=polyfit(x2,BB,1);
    y3(1,:)=polyval(f(i,:),x2);
   
    B=[];
    B=B2(1:sss,:);
    i=2;
    x2=[];y4=[];l=size(B,1)/3;
    BB=B2(l*c-l+1:l*c);
    x2=[l*c-l+1:l*c];
    x2=x2';
    x4=x2;
    f(i,:)=polyfit(x2,BB,1);
    y4(1,:)=polyval(f(i,:),x2);

   
    B=[];
    B=B3(1:sss,:);
    i=3;
    x2=[];y5=[];l=size(B,1)/3;
    x2=[l*c-l+1:l*c];
    BB=B3(l*c-l+1:l*c);
    x2=x2';
    x5=x2;
    f(i,:)=polyfit(x2,BB,1);
    y5(1,:)=polyval(f(i,:),x2);
    
    B=[];
    B=B4(1:sss,:);
    i=4;
    x2=[];y6=[];l=size(B,1)/3;
    x2=[l*c-l+1:l*c];
    BB=B4(l*c-l+1:l*c);
    x2=x2';
    x6=x2;
    f(i,:)=polyfit(x2,BB,1);
    y6(1,:)=polyval(f(i,:),x2);
    
    B=[];
    B=B5(1:ss,:);
    i=5;
    x2=[];y7=[];l=size(B,1)/3;
    x2=[l*c-l+1:l*c];
    BB=B5(l*c-l+1:l*c);
    x2=x2';
    x7=x2;
    f(i,:)=polyfit(x2,BB,1);
    y7(1,:)=polyval(f(i,:),x2);
Slopes(cc:cc+4,1:2)=f;
cc=cc+5;
c=c+1;
P=figure() %FIGURE 7,8,9
plot(1:4,y3','LineWidth',2)
hold on;
plot(1:6,y4','LineWidth',2)
hold on;
plot(1:6,y5','LineWidth',2)
hold on;
plot(1:6,y6','LineWidth',2)
hold on;
plot(1:4,y7','LineWidth',2)
legend('Position1=Farthest from Patient','2','3','4','Position5=Closest to Patient')
xticks([ 1 2 3 4 5 6])
set(gcf,'color','w');
xlabel('Number of Exposure');
ylabel('Rating');
title(strcat('Exposure, Object ',num2str(number)))
%xlim([0 6]);
xticks([ 1 2 3 4 5 6])
ylim([0 10]);
%xticklabels({'1','2','3','4','5','6'});
saveas(P,strcat(Subject,' Object ',i,'Exposure','.fig'))

end

%Alternate Graphs
% q=figure()
% bar(M)
% title('min and max ranges')
% xticklabels({'Object 1','Object 2', 'Object 3'});
% legend('min','max');
% saveas(q,strcat(subj,'Min and Max','.png'))
% 
% figure()
% bar(avg)
% title('Average Values for each Object');
% xticklabels({'Object 1','Object 2', 'Object 3'});
% DifferencePtoNP1=avg(1)-avg(2); 
% DifferencePtoNP2=avg(3)-avg(2);
% %saveas(q,strcat(subj,'Average Values for each Object','.png'))
% 
% save(strcat(subject,'ConveyorBeltAnalysis'),'Slopes','M','avg','-v7.3')

