%ip
m=input('enter mean :')
N=10^6;
variance=input('enter variance:');
deviation=sqrt(variance);
X=m+deviation*randn(1,N);
Y=deviation*randn(1,N);
r=sqrt((X.^2+Y.^2));
%simulated
[f,x]=hist(r,100);
b=trapz(x,f)%actual area
subplot(2,2,1)
plot(x,f);
%unit area
d=trapz(x,f/b)%unit area
subplot(2,2,2);hold on
plot(x,f/b,'b*');
%theoritical
ss=(x.*m)/variance;
g=(x./variance).*exp(-(x.^2+m^2)./(2*variance)).*besseli(0,ss);
plot(x,g,'r');hold off


