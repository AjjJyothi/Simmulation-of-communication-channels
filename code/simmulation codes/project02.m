close all;
clear all;
rng('shuffle');

SNRdB=[1:3:45];
blocklength=100;
numblocks=10000;
BER=zeros(2,length(SNRdB));
SNR=zeros(size(SNRdB));
ipHat=zeros(1,blocklength);


for L=1:numblocks
     bits=randi([0,1],[1,blocklength]);
     ip1 = ((2*(rand(1,blocklength)>0.5))-1)+1j*((2*(rand(1,blocklength)>0.5))-1);
     h=1/sqrt(2)*[randn + j*randn];
     ChNoise=(randn(1,blocklength) + j*randn(1,blocklength));
    
    for k=1:length(SNRdB)
        SNR(k)=10^(SNRdB(k)/10);
        Txbits=sqrt(SNR(k))*(2*bits-1);
        Rxbits=h*Txbits+ChNoise;
        processedbits=conj(h)*Rxbits;
        decodedbits=((real(processedbits))>=0);
        BER(1,k)=sum(decodedbits~=bits)+BER(1,k);
        Txbits1 = sqrt(SNR(k))*ip1;%% Fading channel model
    Rxbits1= h*Txbits1+ ChNoise;
    yHat = h'/norm(h)*Rxbits1; %% Processing with complex conjugate of channel coefficient
    y_re=real(yHat);
    y_im=imag(yHat);
    %qpsk receiver - hard decision decoding
    ipHat(find(y_re>0&y_im>0))= 1+1j;
    ipHat(find(y_re<0&y_im>0))= -1+1j;
    ipHat(find(y_re>0&y_im<0))= 1-1j;
    ipHat(find(y_re<0&y_im<0))= -1-1j;
    BER(2,k) = BER(2,k) + sum(ipHat ~= ip1);
    end
    
end

BER1=BER(1,:)/(numblocks*blocklength);
BER2 = BER(2,:)/(numblocks*blocklength);
semilogy(SNRdB,BER1,'b-s','linewidth',2.0);hold on;
semilogy(SNRdB,BER2,'r-s','linewidth',2.0);
semilogy(SNRdB,0.5*(1-sqrt(SNR./(2+SNR))),'b*','linewidth',2.0);
semilogy(SNRdB,(1-sqrt(SNR./(2+SNR))),'r*','linewidth',2.0);
axis tight
grid on
legend('bpsk simulated','Qpsk simulated','bpsk theory','Qpsk theory');
xlabel('SNR(dB)');
ylabel('BER');
title('BER vs SNR(dB) of relay channel')
