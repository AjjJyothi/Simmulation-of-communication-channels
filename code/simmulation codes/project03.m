close all;
clear all; 
rng('shuffle');
% Reinitialize the random number generator used by RAND, rands, and RANDN 
SNRdB = [1:4:30];
blockLength = 1000; 
numBlocks =10000; 
BER = zeros(3,length(SNRdB));
SNR = zeros(1,length(SNRdB)); 
numAnt=[1 2 3]; %Rxer antennas
for i=1:length(numAnt)
for L = 1:numBlocks 
ChNoise = (randn(numAnt(i),blockLength)+1j*randn(numAnt(i),blockLength));%AWGN noise
bits= randi([0,1],[1,blockLength]);
h = 1/sqrt(2)*(randn(numAnt(i),1)+ 1j*randn(numAnt(i),1));%relay fading noise 
for K = 1:length(SNRdB) 
    SNR(K) = 10^(SNRdB(K)/10);%SNR NOT IN DB
    Txbits = sqrt(SNR(K))*(2*bits-1);%% Fading channel model
    Rxbits= h*Txbits+ ChNoise ;
    ProcessedBits = h'/norm(h)*Rxbits; %% Processing with complex conjugate of channel coefficient
    DecodedBits =((real(ProcessedBits)) >= 0);
    BER(i,K) = BER(i,K) + sum(DecodedBits ~= bits);
end
end
end
BER
BER = BER/(numBlocks*blockLength);
semilogy(SNRdB,BER(1,:),'r-s');hold on;
semilogy(SNRdB,nchoosek(2*numAnt(1)-1,numAnt(1)-1)*( 1./((2*SNR).^numAnt(1))),'r ');
lamda1=sqrt(SNR./(2+SNR));
acc1=(((1-lamda1)./2).^numAnt(1));
semilogy(SNRdB,acc1,'r*');
semilogy(SNRdB,BER(2,:),'b-s');
semilogy(SNRdB,nchoosek(2*numAnt(2)-1,numAnt(2)-1)*(1./((2*SNR).^numAnt(2))) ,'b-');
lamda2=sqrt(SNR./(2+SNR));
acc2=(((1-lamda2)./2).^numAnt(2)).*(1+(2.*(((1+lamda2)./2).^numAnt(2))));
semilogy(SNRdB,acc2,'b*');
semilogy(SNRdB,BER(3,:),'g-s');hold on;
semilogy(SNRdB,nchoosek(2*numAnt(3)-1,numAnt(3)-1)*(1./((2*SNR).^numAnt(3))) ,'g');
lamda3=sqrt(SNR./(2+SNR));
acc3=(((1-lamda3)./2).^numAnt(3)).*(2+(3.*(((1+lamda3)./2).^numAnt(3)))+(6.*(((1+lamda3)./2).^numAnt(3))));
semilogy(SNRdB,acc3,'g*');
axis tight;
grid on;
legend('nRx=1 simulated','nRx=1 theory','nRx=1 accurate','nRx=2 simulated','nRx=2 theory','nRx=2 accurate','nRx=3 simulated','nRx=3 theory','nRx=3 accurate') 
xlabel('SNR(dB)'); 
ylabel('BER');
title('MRC');
title('BER vs SNR(dB)');

