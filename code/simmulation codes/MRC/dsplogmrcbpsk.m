% Script for computing the BER for BPSK modulation in a
% Rayleigh fading channel with Maximal Ratio Combining

clear
N = 10^6; % number of bits or symbols
rng('shuffle');

% Transmitter
ip = ((2*(rand(1,N)>0.5))-1)+1j*((2*(rand(1,N)>0.5))-1); % BPSK modulation 0 -> -1; 1 -> 0
s=(1/sqrt(2))*ip;
nRx =  [1,2];
Eb_N0_dB = [0:35]; % multiple Eb/N0 values
ipHat=zeros(1,N);

for jj = 1:length(nRx)

    for ii = 1:length(Eb_N0_dB)

        n = 1/sqrt(2)*[randn(nRx(jj),N) + j*randn(nRx(jj),N)]; % white gaussian noise, 0dB variance
        h = 1/sqrt(2)*[randn(nRx(jj),N) + j*randn(nRx(jj),N)]; % Rayleigh channel

        % Channel and noise Noise addition
    
        y = h.*s+ 10^(-Eb_N0_dB(ii)/20)*n;

        % equalization maximal ratio combining 
        yHat =  sum(conj(h).*y,1)./sum(h.*conj(h),1);
        y_re=real(yHat);
        y_im=imag(yHat);
        

        % receiver - hard decision decoding
        ipHat(find(y_re>0&y_im>0))= 1+1j;
        ipHat(find(y_re>0&y_im<0))= 1-1j;
        ipHat(find(y_re<0&y_im>0))= -1+1j;
        ipHat(find(y_re<0&y_im<0))= -1-1j;


        % counting the errors
        nErr(jj,ii) = size(find([ip-ipHat]),2);

    end

end
simBer = nErr/N; % simulated ber
EbN0Lin = 10.^(Eb_N0_dB/10);
%theoryBer_nRx1 = 0.5.*(1-1*(1+1./EbN0Lin).^(-0.5)); 
%p = 1/2 - 1/2*(1+1./EbN0Lin).^(-1/2);
%theoryBer_nRx2 = p.^2.*(1+2*(1-p)); 

close all
figure
%semilogy(Eb_N0_dB,theoryBer_nRx1,'bp-','LineWidth',2);
semilogy(Eb_N0_dB,simBer(1,:),'r-s','LineWidth',2);hold on;
%semilogy(Eb_N0_dB,theoryBer_nRx2,'b','LineWidth',2);
semilogy(Eb_N0_dB,simBer(2,:),'b-s','LineWidth',2);hold off;
axis([0 35 10^-5 0.5])
grid on
legend( 'nRx=1 (sim)','nRx=2 (sim)');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for BPSK modulation with Maximal Ratio Combining in Rayleigh channel');


