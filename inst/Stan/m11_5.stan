data{
    int n;
    int pulled_left[n];
    int actor[n];
    int side[n];
    int cond[n];
}

parameters{
    vector[7] a;
    vector[2] bs;
    vector[2] bc;
}

model{
    vector[n] p;
    a ~ normal(0, 1.5);
    bs ~ normal(0, 0.5);
    bc ~ normal(0, 0.5); 
    for (i in 1:n) {
        p[i] = a[actor[i]] + bs[side[i]] + bc[cond[i]];
        p[i] = inv_logit(p[i]);
    }
    pulled_left ~ binomial(1, p);
}

generated quantities{
    vector[n] log_lik;
    vector[n] p;
    for (i in 1:n) {
        p[i] = a[actor[i]] + bs[side[i]] + bc[cond[i]];
        p[i] = inv_logit(p[i]);
    }
    for (i in 1:n) {
      log_lik[i] = binomial_lpmf(pulled_left[i] | 1, p[i]);
    }
}
