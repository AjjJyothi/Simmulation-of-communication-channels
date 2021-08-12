close all;
clear all; 
rng('shuffle'); 
%Reinitialize the random number generator used by RAND, randi, and RANDN 
SNRdB=[1:4:40]; 
blockLength=1000; 
numBlocks= 10000; 
BER= zeros(3,length(SNRdB)); 
SNR= zeros(size(SNRdB)); 
numRxAnt= [2 3 4]; 
numTxAnt1 = 2;
for i=1:length(numRxAnt)
for L= 1:numBlocks 
    H = 1/sqrt(2)*(randn(numRxAnt(i),numTxAnt1)+j*randn(numRxAnt(i),numTxAnt1));
    bits= randi([0,1],[numTxAnt1,blockLength]); 
    ChNoise = (randn(numRxAnt(i),blockLength)+j*randn(numRxAnt(i),blockLength));
    for K = 1:length(SNRdB)  
        SNR(K) =10^(SNRdB(K)/10);
        Txbits = sqrt(SNR(K))*(2*bits-1); 
        Rxbits = H*Txbits + ChNoise; 
        ProcessedBits=pinv(H)*Rxbits;
        DecodedBits=((real(ProcessedBits)) >= 0); 
        BER(i,K) = BER(i,K) + sum(sum(DecodedBits ~= bits));
    end 
end
end
BER
dord1= numRxAnt(1)-numTxAnt1+1; 
dord2= numRxAnt(2)-numTxAnt1+1;
dord3= numRxAnt(3)-numTxAnt1+1;
BER = BER/(numBlocks*blockLength*numTxAnt1);  
semilogy(SNRdB,BER(1,:),'b-s');hold on; 
semilogy(SNRdB,nchoosek(2*dord1-1,dord1)*(1./((2.*SNR).^dord1)),'b-.'); 
semilogy(SNRdB,BER(2,:),'r-s');hold on; 
semilogy(SNRdB,nchoosek(2*dord2-1,dord2)*(1./((2.*SNR).^dord2)),'r-.');
semilogy(SNRdB,BER(3,:),'g-s');hold on; 
semilogy(SNRdB,nchoosek(2*dord3-1,dord3)*(1./((2.*SNR).^dord3)),'g-.');
axis tight; 
grid on; 
legend('rx=2 simulated','rx=2 theory','rx=3 simulated','rx=3 theory','rx=4 simulated','rx=4 theory');
xlabel('SNR(dB)'); 
ylabel('BER');
title('MIMO');
title('BER vs SNR(dB)'); 

