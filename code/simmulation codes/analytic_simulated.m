clc;
%mean will varry in given deviation
a=randn(1,10000000);
m=mean(a)
s=std(a(:))
v=var(a)
[f,x]=hist(a,100);
b=trapz(x,f)%actual area
subplot(2,2,1)
bar(x,f);
%unit area
d=trapz(x,f/b)%unit area
subplot(2,2,2);hold on
bar(x,f/b);
g=1/sqrt(2*pi)*exp(-0.5*(x).^2);
plot(x,g,'r');hold off