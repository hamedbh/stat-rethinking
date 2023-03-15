data{
    int n;
    array[n] int pulled_left;
    array[n] int treatment;
    array[n] int actor;
}

parameters{
    real a;
    vector[4] b;
}

model{
    vector[n] p;
    b ~ normal(0, 0.5);
    a ~ normal(0, 1.5);
    for (i in 1:n) {
        p[i] = inv_logit(a + b[treatment[i]]);
    }
    pulled_left ~ bernoulli(p);
}
generated quantities{
    vector[n] log_lik;
    vector[n] p;
    for (i in 1:n) {
        p[i] = inv_logit(a + b[treatment[i]]);
    }
    for (i in 1:n) {
      log_lik[i] = bernoulli_lpmf(pulled_left[i] | p[i]);
    }
}
