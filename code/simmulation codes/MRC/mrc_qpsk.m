% Script for computing the BER for BPSK modulation in a
% Rayleigh fading channel with Maximal Ratio Combining

N = 10^5;% number of symbols
Es_N0_dB = [0:35]; % multiple Eb/N0 values
ipHat = zeros(1,N);

nRx =  [1 2];
for jj = 1:length(nRx)

    for ii = 1:length(Es_N0_dB)

	ip = (2*(rand(1,N)>0.5)-1) + j*(2*(rand(1,N)>0.5)-1); %
	s = (1/sqrt(2))*ip; % normalization of energy to 1
	n = 1/sqrt(2)*[randn(1,N) + j*randn(1,N)]; % white guassian 	noise, 0dB variance
    h = 1/sqrt(2)*[randn(nRx(jj),N) + j*randn(nRx(jj),N)]; % Rayleigh channel

        % Channel and noise Noise addition
        sD = kron(ones(nRx(jj),1),s);
        y = h.*s + 10^(-Es_N0_dB(ii)/20)*n; % additive white gaussian noise

        % equalization maximal ratio combining 
        %yHat =  sum(conj(h).*y,1)./sum(h.*conj(h),1); 

        % receiver - hard decision decoding
        y_re = real(y); % real
	y_im = imag(y); % imaginary
	ipHat(find(y_re < 0 & y_im < 0)) = -1 + -1*j;
	ipHat(find(y_re >= 0 & y_im > 0)) = 1 + 1*j;
	ipHat(find(y_re < 0 & y_im >= 0)) = -1 + 1*j;
	ipHat(find(y_re >= 0 & y_im < 0)) = 1 - 1*j;

        % counting the errors
        nErr(jj,ii) = size(find([ip- ipHat]),2);

    end

end

simBer = nErr/N; % simulated ber
EbN0Lin = 10.^(Eb_N0_dB/10);
theoryBer_nRx1 = 0.5.*(1-1*(1+1./EbN0Lin).^(-0.5)); 
p = 1/2 - 1/2*(1+1./EbN0Lin).^(-1/2);
theoryBer_nRx2 = p.^2.*(1+2*(1-p)); 

close all
figure
semilogy(Eb_N0_dB,theoryBer_nRx1,'bp-','LineWidth',2);
hold on
semilogy(Eb_N0_dB,simBer(1,:),'mo-','LineWidth',2);
semilogy(Eb_N0_dB,theoryBer_nRx2,'rd-','LineWidth',2);
semilogy(Eb_N0_dB,simBer(2,:),'ks-','LineWidth',2);
axis([0 35 10^-5 0.5])
grid on
legend('nRx=1 (theory)', 'nRx=1 (sim)', 'nRx=2 (theory)', 'nRx=2 (sim)');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for QPSK modulation with Maximal Ratio Combining in Rayleigh channel');

