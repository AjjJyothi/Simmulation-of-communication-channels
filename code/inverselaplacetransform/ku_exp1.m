function [ F ] = ku_exp1( samples )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
close all;
gm=0:0.1:10; 
gm1=10.^(gm/10);
%M=@(s)(1/(s+1));
%M=@(s)(1/(s-1));
M=@(s)(1/(s-(1/6)))
A=18.4;N=15;K=11;
Discretisation_error=exp(-A);
%TRUNCATION ERROR
for i=1:length(gm)
    Gm=10^(gm(i)/10);
    Sm1=0;
    for k=0:K
        Sm1=Sm1+2^(-K)*(-1)^(N+1+k)*(gamma(K+1)/(gamma(k+1)*gamma(K+1-k)))*real(M((A+1j*2*pi*(N+k+1))/(2*Gm)));
    end
    Truncation_Error=(exp(A/2)/Gm)*Sm1;
    Sm2=0;
    for k=0:K
        Sm3=0;
        for n=0:N+k
            if n==0
                Alpha_n=2;
            else
                Alpha_n=1;
            end
            Sm3=Sm3+((-1)^n/Alpha_n)*real(M((A+1j*2*pi*n)/(2*Gm)));
        end
        Sm2=Sm2+2^(-K)*(gamma(K+1)/(gamma(k+1)*gamma(K+1-k)))*((exp(A/2)/Gm)*Sm3);
    end
    pdf(i)=double(Sm2+Discretisation_error+Truncation_Error);
end
rnd = rand(1, samples);
F = interp1(gm1,pdf,rnd,'spline');
%y=exp(-1*rnd);
%y=exp(1*rnd);
y=exp((1/6)*rnd);
plot(rnd,F,'r'); hold on;
plot(rnd,y,'b*');hold off
end