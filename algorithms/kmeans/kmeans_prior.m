function p = kmeans_prior(theta)
% K means prior probabilities. The prior is as follows:
%
% window_size ~ discreteunif(10,40)
% whitening_dim ~ discreteunif(1,window_size.^2)
% num_bases ~ discreteunif(1,400)
% delta ~ exp(5)
% 

p = discunifpdf(theta(1,:),10,40).*discunifpdf(theta(2,:),1,theta(1,:).^2).*discunifpdf(theta(3,:),1,400).*exppdf(theta(4,:),5);