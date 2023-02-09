data{
    int n;
    int pulled_left[n];
    int treatment[n];
    int actor[n];
}

parameters{
    vector[7] a;
    vector[4] b;
}

model{
    vector[n] p;
    b ~ normal(0, 0.5);
    a ~ normal(0, 1.5);
    for (i in 1:n) {
        p[i] = a[actor[i]] + b[treatment[i]];
        p[i] = inv_logit(p[i]);
    }
    pulled_left ~ binomial(1, p);
}
generated quantities{
    vector[n] log_lik;
    vector[n] p;
    for (i in 1:n) {
        p[i] = a[actor[i]] + b[treatment[i]];
        p[i] = inv_logit(p[i]);
    }
    for (i in 1:n) {
      log_lik[i] = binomial_lpmf(pulled_left[i] | 1, p[i]);
    }
}
