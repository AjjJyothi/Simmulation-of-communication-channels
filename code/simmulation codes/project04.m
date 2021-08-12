close all;
clear all; 
rng('shuffle'); 
%Reinitialize the random number generator used by RAND, randi, and RANDN 
SNRdB=[1:4:40]; 
blockLength=1000; 
numBlocks= 10000; 
BER= zeros(size(SNRdB)); 
SNR= zeros(size(SNRdB)); 
numRxAnt = 2; 
numTxAnt = 2; 
bits= randi([0,1],[numTxAnt,blockLength]); 
for L= 1:numBlocks 
    H = 1/sqrt(2)*(randn(numRxAnt,numTxAnt)+j*randn(numRxAnt,numTxAnt)); 
    for K = length(SNRdB)  
        ChNoise = (randn(numRxAnt,blockLength)+j*randn(numRxAnt,blockLength));
        SNR(K) =10^(SNRdB(K)/10); 
        Txbits = sqrt(SNR(K))*(2*bits-1); 
        Rxbits = H*Txbits + ChNoise; 
        ProcessedBits=pinv(H)*Rxbits; 
        DecodedBits=((real(ProcessedBits)) >= 0); 
        BER(K) = BER(K) + sum(sum(DecodedBits ~= bits));
    end 
end
dord= numRxAnt-numTxAnt+1; 
BER = BER/(numBlocks*blockLength*numTxAnt); 
semilogy(SNRdB,BER,'b - s')
hold on; 
semilogy(SNRdB,nchoosek(2*dord-1,dord-1)*1/2^dord./SNR.^dord,'r-.'); 
axis tight; 
grid on; 
legend('MIMO','Theory');
xlabel('SNR(dB)'); 
ylabel('BER');
title('BER vs SNR(dB)'); 

