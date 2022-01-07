data{
    int n;
    vector[n] M;
    vector[n] D;
    vector[n] A;
}

parameters{
    real a;
    real bM;
    real<lower=0> sigma;
}

model{
    vector[n] mu;
    sigma ~ exponential(1);
    bM ~ normal(0, 0.5);
    a ~ normal(0, 0.2);
    for (i in 1:n) {
        mu[i] = a + (bM * M[i]);
    }
    D ~ normal(mu, sigma);
}

generated quantities{
    vector[n] log_lik;
    vector[n] mu;
    for ( i in 1:50 ) {
        mu[i] = a + (bM * M[i]);
    }
    for (i in 1:n) {
      log_lik[i] = normal_lpdf(D[i] | mu[i], sigma); 
    }
}
