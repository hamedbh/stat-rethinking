data{
    int<lower = 1> n ; // number of observations, included by compose_data()
    vector[n] log_gdp_std; // can now use n instead of hardcoding 170
    vector[n] rugged_std; 
    int region[n]; 
}

parameters{
    real<lower = 0> sigma;
    vector[2] a; 
    vector[2] b; 
}

model{
    vector[n] mu; 
    for (i in 1:n) {
        mu[i] = a[region[i]] + (b[region[i]] * (rugged_std[i] - 0.215));
    }
    a ~ normal(0, 0.1); 
    b ~ normal(0, 0.3); 
    sigma ~ uniform(0, 1); 
    log_gdp_std ~ normal(mu, sigma);
}
