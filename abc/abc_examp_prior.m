function p = abc_examp_prior(thetas)
delta_prior = 5;
p = unifpdf(thetas(1,:)).*exppdf(thetas(2,:),delta_prior);