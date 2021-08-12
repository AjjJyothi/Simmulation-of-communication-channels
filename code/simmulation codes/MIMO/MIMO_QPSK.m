close all;
clear all; 
rng('shuffle'); 
%Reinitialize the random number generator used by RAND, randi, and RANDN 
SNRdB=[1:4:40]; 
blockLength=1000; 
numBlocks= 10000; 
BER= zeros(2,length(SNRdB)); 
SNR= zeros(size(SNRdB)); 
numRxAnt1 = 2; 
numTxAnt1 = 2; 
for L= 1:numBlocks 
    H = 1/sqrt(2)*(randn(numRxAnt1,numTxAnt1)+j*randn(numRxAnt1,numTxAnt1));
    bits= randi([0,1],[numTxAnt1,blockLength]);
    ip=((2*rand(numTxAnt1,blockLength))-1)+1j*((2*rand(numTxAnt1,blockLength))-1);
    ipHat=zeros(numTxAnt1,blockLength);
    ChNoise = (randn(numRxAnt1,blockLength)+j*randn(numRxAnt1,blockLength));
    for K = 1:length(SNRdB)  
        SNR(K) =10^(SNRdB(K)/10);
        Txbits1 = sqrt(SNR(K))*(2*bits-1); 
        Rxbits1 = H*Txbits1 + ChNoise; 
        ProcessedBits1=pinv(H)*Rxbits1; 
        DecodedBits=((real(ProcessedBits1)) >= 0); 
        BER(1,K) = BER(1,K) + sum(sum(DecodedBits ~= bits));
        Txbits2 = sqrt(SNR(K))*ip; 
        Rxbits2 = H*Txbits2 + ChNoise; 
        yHat=pinv(H)*Rxbits2;
        y_re=real(yHat);
        y_im=imag(yHat);
    %qpsk receiver - hard decision decoding
    ipHat(find(y_re>0&y_im>0))= 1+1j;
    ipHat(find(y_re<0&y_im>0))= -1+1j;
    ipHat(find(y_re>0&y_im<0))= 1-1j;
    ipHat(find(y_re<0&y_im<0))= -1-1j;
    BER(2,K) = BER(2,K) + sum(sum(ipHat ~= ip));
        
    end 
end
dord= numRxAnt1-numTxAnt1+1; 
BER = BER/(numBlocks*blockLength*numTxAnt1); 
semilogy(SNRdB,BER(1,:),'b - s')
hold on; 
semilogy(SNRdB,nchoosek(2*dord-1,dord)*1./((2.*SNR).^dord),'b-.'); 
semilogy(SNRdB,BER(2,:),'r - s')
axis tight; 
grid on; 
legend('MIMO_BPSK','Theory_BPSK','MIMO_QPSK');
xlabel('SNR(dB)'); 
ylabel('BER');
title('BER vs SNR(dB)'); 

