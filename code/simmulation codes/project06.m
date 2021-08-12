close all;
 clear all;
 rng('shuffle'); 
SNRdB = [1:5:45]; 
Nsub = 512;
 Ncp = round(Nsub/10);
 numBlocks = 10000;
 numTaps = 2;
 numAnt = 2;
 BER = zeros(size(SNRdB));
 SNR = zeros(size(SNRdB));
 for L = 1:numBlocks
 bits = randi([0,1],[1,Nsub]);
 h = 1/sqrt(2)*(randn(numAnt,numTaps) + 1i*randn(numAnt,numTaps)); Hfreq = fft([h,zeros(2,Nsub-numTaps)],[],2);
 ChNoise = (randn(numAnt,numTaps+Nsub+Ncp-1) + 1i*randn(numAnt,numTaps+Nsub+Ncp-1));

for K = 1:length(SNRdB) 
SNR(K) = 10^(SNRdB(K)/10);
 Loadedbits = sqrt(SNR(K))*(2*bits-1); %% Fading channel model TxSamples = ifft(Loadedbits);
 TxSamples=ifft(Loadedbits);
 TxSamplesCp =[TxSamples(Nsub-Ncp+1:Nsub),TxSamples];
 Rxbits = [];
 for rxi = 1:numAnt 
 Rxbits = [Rxbits; conv(h(rxi,:),TxSamplesCp) + ChNoise(rxi,:)]; 
end 

RxbitsWithoutCp = Rxbits(:,Ncp+1:Ncp+Nsub);
 RxbitsFFT = fft(RxbitsWithoutCp,[],2);
 ProcessedBits = sum(RxbitsFFT.*conj(Hfreq)); %% Processing with complex conjugate of channel coefficient 
DecodedBits = ((real(ProcessedBits)) >= 0);
 BER(K) = BER(K) + sum(DecodedBits ~= bits);
 end 
 end
 eSNR = numTaps*SNR/Nsub;
 BER = BER/(numBlocks*Nsub);
 semilogy(SNRdB,BER,'b - s','linewidth',2.0);
 hold on;
 semilogy(SNRdB,(1/2)*(1-sqrt(eSNR./(2+eSNR))),'r-','linewidth',2.0);


 axis tight; 
 grid on;
 legend('MRC','TheorN Single Ant')
 xlabel('SNR (dB)');
 ylabel('BER');
 title('BER vs SNR(dB)'); 
