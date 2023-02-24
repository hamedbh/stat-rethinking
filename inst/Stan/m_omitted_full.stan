data{
    int n;
    array[n] int y;
    vector[n] z;
    vector[n] x;
}

parameters{
    real a;
    real bZ;
    real bX;
}

model{
    vector[n] p;
    bX ~ normal(0, 0.5);
    bZ ~ normal(0, 0.5);
    a ~ normal(0, 0.5);
    for (i in 1:n) {
        p[i] = inv_logit(a + (bX * x[i]) + (bZ * z[i]));
    }
    y ~ binomial(1, p);
}

generated quantities {
    vector[n] p;
    vector[n] log_lik;
    for (i in 1:n) {
        p[i] = inv_logit(a + (bX * x[i]) + (bZ * z[i]));
    }
    for (i in 1:n) {
        log_lik[i] = binomial_lpmf(y[i] | 1, p[i]);
    }
}
