% Rayleigh PDF
% Input

N=10^6;
variance=input('enter variance:');
X=randn(1,N);
Y=randn(1,N);
r=sqrt(variance*(X.^2+Y.^2));

% Histogram plot
step=0.1;
range=0:step:3;
h=hist(r,range);
PDF=h/(step*sum(h));
theory=(range/variance).*exp(-range.^2/(2*variance));
plot(range,PDF,'b*',range,theory,'r');
hold on;
