close all;
clear all; 
rng('shuffle');
% Reinitialize the random number generator used by RAND, rands, and RANDN 
SNRdB = [1:4:30];
blockLength = 100; 
numBlocks =100; 
BER = zeros(1,length(SNRdB));
SNR = zeros(1,length(SNRdB)); 
numAnt=2; %Rxer antennas
for L = 1:numBlocks 
ChNoise= (randn(numAnt,blockLength)+1j*randn(numAnt,blockLength));%AWGN noise
ip1 = ((2*(rand(1,blockLength)>0.5))-1)+1j*((2*(rand(1,blockLength)>0.5))-1);
ipHat=zeros(1,blockLength);
h = 1/sqrt(2)*(randn(numAnt,1)+ 1j*randn(numAnt,1));%relay fading noise 
for K = 1:length(SNRdB) 
    SNR(K) = 10^(SNRdB(K)/10);%SNR NOT IN DB
    Txbits1 = sqrt(SNR(K))*ip1;%% Fading channel model
    Rxbits1= h*Txbits1+ ChNoise;
    yHat =( h'/norm(h))*Rxbits1; %% Processing with complex conjugate of channel coefficient
    y_re=real(yHat);
    y_im=imag(yHat);
    %qpsk receiver - hard decision decoding
    ipHat(find(y_re>0&y_im>0))= 1+1j;
    ipHat(find(y_re<0&y_im>0))= -1+1j;
    ipHat(find(y_re>0&y_im<0))= 1-1j;
    ipHat(find(y_re<0&y_im<0))= -1-1j;
    BER(K) = BER(K) + sum(ipHat ~= ip1);
end
end
BER1 = BER/(numBlocks*blockLength);
semilogy(SNRdB,BER1,'r-s');hold on;
semilogy(SNRdB,(((1./(SNR)).^numAnt).*5),'r');
axis tight;
grid on;
%legend('nRx=2 qpsk simulated','nRx=2 qpsk theory','nRx=2 bpsk simulated','nRx=2 bpsk theory');
xlabel('SNR(dB)'); 
ylabel('BER');
title('BER vs SNR(dB)');
