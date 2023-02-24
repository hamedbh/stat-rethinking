data {
  int n; 
  array[n] int sp_id; 
  array[n] int age; 
  vector[n] mass;
}

parameters{
    vector<lower=0>[6] c;
    vector<lower=0>[6] k;
    vector[6] S;
    real<lower=0> sigma;
}
model{
    vector[n] mu;
    sigma ~ exponential(1);
    S ~ normal(1, 0.5);
    k ~ exponential(1);
    c ~ exponential(0.1);
    for (i in 1:n) {
        mu[i] = S[sp_id[i]] * (1 - exp(-k[sp_id[i]] * age[i]))^c[sp_id[i]];
    }
    mass ~ normal(mu, sigma);
}
generated quantities{
    vector[n] log_lik;
    vector[n] mu;
    for (i in 1:n) {
      mu[i] = S[sp_id[i]] * (1 - exp(-k[sp_id[i]] * age[i]))^c[sp_id[i]];
    }
    for (i in 1:32) {
      log_lik[i] = normal_lpdf( mass[i] | mu[i] , sigma );
    }
}
