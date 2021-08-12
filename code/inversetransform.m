clc;
close all;
N = 1000;
% BETA PARAMETERS
alpha = 10; beta = 10;
% DRAW PROPOSAL SAMPLES
z = rand(1,N);
% EVALUATE PROPOSAL SAMPLES AT INVERSE CDF
samples = icdf('beta',z,alpha,beta)
%samples = icdf('exp',z,beta)
bins = linspace(0,1,50)
counts = hist(samples,bins)
probSampled = counts/sum(counts);
probTheory = betapdf(bins,alpha,beta);
%probTheory = exppdf(bins,beta);
% DISPLAY
b = bar(bins,probSampled,'FaceColor',[.9 .9 .9]);
hold on;
t = plot(bins,probTheory/sum(probTheory),'r','LineWidth',2);
xlim([0 1])
xlabel('x')
ylabel('p(x)')
legend([t,b],{'Theory','IT Samples'})
% % hold 