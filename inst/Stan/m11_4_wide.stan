data{
    int n;
    array[n] int pulled_left;
    array[n] int treatment;
    array[n] int actor;
}

parameters{
    vector[7] a;
    vector[4] b;
}

model{
    vector[n] p;
    b ~ normal(0, 0.5);
    a ~ normal(0, 10);
    for (i in 1:n) {
        p[i] = inv_logit(a[actor[i]] + b[treatment[i]]);
    }
    pulled_left ~ binomial(1, p);
}
generated quantities{
    vector[n] log_lik;
    vector[n] p;
    for (i in 1:n) {
        p[i] = inv_logit(a[actor[i]] + b[treatment[i]]);
    }
    for (i in 1:n) {
      log_lik[i] = binomial_lpmf(pulled_left[i] | 1, p[i]);
    }
}
