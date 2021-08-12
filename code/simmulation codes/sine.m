clc;
close all;
t=0:0.01:10;
t1=0:0.01:10-0.01;
x=sin(t)
y=diff(x)./0.01
plot(t,x,'b');hold on;
plot(t1,y,'r')