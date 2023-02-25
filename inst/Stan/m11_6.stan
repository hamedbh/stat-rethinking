data{
    int n;
    array[n] int treatment;
    array[n] int actor;
    array[n] int side;
    array[n] int cond;
    array[n] int n_trials;
    array[n] int left_pulls;
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
        p[i] = inv_logit(a[actor[i]] + b[treatment[i]]);
    }
    left_pulls ~ binomial(n_trials, p);
}
generated quantities{
    vector[n] log_lik;
    vector[n] p;
    for (i in 1:n) {
        p[i] = inv_logit(a[actor[i]] + b[treatment[i]]);
    }
    for (i in 1:n) {
      log_lik[i] = binomial_lpmf(left_pulls[i] | n_trials[i], p[i]);
    }
}
