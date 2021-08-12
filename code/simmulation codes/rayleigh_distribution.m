v%ip
N=10^6;
variance=input('enter variance:');
mean=0;
X=randn(1,N);
Y=randn(1,N);
r=sqrt(variance*(X.^2+Y.^2));
%simulated
[f,x]=hist(r,100);
x
b=trapz(x,f)%actual area
subplot(2,2,1)
plot(x,f);
%unit area
d=trapz(x,f/b)%unit area
subplot(2,2,2);hold on;
plot(x,f/b,'b*');
g=(x/variance).*exp((-x.^2)/(2*variance));
plot(x,g,'r');hold off;

