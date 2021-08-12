close all;
clear all;
rng('shuffle');

SNRdB=[1:.5:13];
blocklength=1000000;
bits=randi([0,1],[1,blocklength]);
BER=zeros(size(SNRdB));
SNR=zeros(size(SNRdB));
ChNoise=[randn(1,blocklength) + j*randn(1,blocklength)];
    
    for k=1:length(SNRdB)
     bits=randi([0,1],[1,blocklength]);
        SNR=10^(SNRdB(k)/10);
        Txbits=sqrt(SNR)*(2*bits-1);
        Rxbits=Txbits+ChNoise;
        decodedbits=((real(Rxbits))>=0);
        BER(k)=sum(decodedbits~=bits)/blocklength;
    end
semilogy(SNRdB,BER,'b s','linewidth',2.0);
hold on
semilogy(SNRdB,qfunc(sqrt(10.^(SNRdB/10))),'r-.','linewidth',2.0);
axis tight
grid on
legend('AWGN','theory');
xlabel('SNR(dB)');
ylabel('BER');
title('BER vs SNR(dB)')
