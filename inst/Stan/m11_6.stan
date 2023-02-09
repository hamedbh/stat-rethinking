data{
    int n;
    int treatment[n];
    int actor[n];
    int side[n];
    int cond[n];
    int n_trials[n];
    int left_pulls[n];
}

parameters{
    vector[7] a;
    vector[4] b;
}

model{
    vector[n] p;
    a ~ normal(0, 1.5);
    b ~ normal(0, 0.5);
    for (i in 1:n) {
        p[i] = a[actor[i]] + b[treatment[i]];
        p[i] = inv_logit(p[i]);
    }
    left_pulls ~ binomial(n_trials, p);
}
generated quantities{
    vector[n] log_lik;
    vector[n] p;
    for (i in 1:n) {
        p[i] = a[actor[i]] + b[treatment[i]];
        p[i] = inv_logit(p[i]);
    }
    for (i in 1:n) {
      log_lik[i] = binomial_lpmf(left_pulls[i] | n_trials[i], p[i]);
    }
}
