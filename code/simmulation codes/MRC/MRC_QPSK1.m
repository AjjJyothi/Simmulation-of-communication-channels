close all;
clear all; 
rng('shuffle');
% Reinitialize the random number generator used by RAND, rands, and RANDN 
SNRdB = [1:4:30];
blockLength = 1000; 
numBlocks =10000; 
BER = zeros(2,length(SNRdB));
SNR = zeros(1,length(SNRdB)); 
numAnt=2; %Rxer antennas
for L = 1:numBlocks 
ChNoise= (randn(numAnt,blockLength)+1j*randn(numAnt,blockLength));%AWGN noise
ip1 = ((2*(rand(1,blockLength)>0.5))-1)+1j*((2*(rand(1,blockLength)>0.5))-1);
bits= randi([0,1],[1,blockLength]);
ipHat=zeros(1,blockLength);
h = 1/sqrt(2)*(randn(numAnt,1)+ 1j*randn(numAnt,1));%relay fading noise 
for K = 1:length(SNRdB) 
    SNR(K) = 10^(SNRdB(K)/10);%SNR NOT IN DB
    Txbits1 = sqrt(SNR(K))*ip1;%% Fading channel model
    Rxbits1= h*Txbits1+ ChNoise;
    yHat = h'/norm(h)*Rxbits1; %% Processing with complex conjugate of channel coefficient
    y_re=real(yHat);
    y_im=imag(yHat);
    %qpsk receiver - hard decision decoding
    ipHat(find(y_re>0&y_im>0))= 1+1j;
    ipHat(find(y_re<0&y_im>0))= -1+1j;
    ipHat(find(y_re>0&y_im<0))= 1-1j;
    ipHat(find(y_re<0&y_im<0))= -1-1j;
    BER(1,K) = BER(1,K) + sum(ipHat ~= ip1);
    Txbits = sqrt(SNR(K))*(2*bits-1);%% Fading channel model
    Rxbits= h*Txbits+ ChNoise;
    ProcessedBits = h'/norm(h)*Rxbits; %% Processing with complex conjugate of channel coefficient
    DecodedBits =((real(ProcessedBits)) >= 0);
    BER(2,K) = BER(2,K) + sum(DecodedBits ~= bits);
end
end
BER1 = BER(1,:)/(numBlocks*blockLength);
BER2 = BER(2,:)/(numBlocks*blockLength);
semilogy(SNRdB,BER1,'r-s');hold on;
lamda1=sqrt(SNR./(2+SNR));
acc1=((1-lamda1).^numAnt).*(1+(2.*(((1+lamda1)).^numAnt)));
%semilogy(SNRdB,acc1,'r*');
semilogy(SNRdB,BER2,'b-s');
lamda2=sqrt(SNR./(2+SNR));
acc2=(((1-lamda2)./2).^numAnt).*(1+(2.*(((1+lamda2)./2).^numAnt)));
semilogy(SNRdB,acc2,'b*');hold off;
axis tight;
grid on;
legend('nRx=2 qpsk simulated','nRx=2 qpsk theory','nRx=2 bpsk simulated');
xlabel('SNR(dB)'); 
ylabel('BER');
title('MRC');
title('BER vs SNR(dB)');
