data {
    int n;
    array[n] int y;
    array[n] int sample_size;
    array[n] int P;
    array[n] int V;
    array[n] int A;
}

parameters {
   real a;
   real bV;
   real bP;
   real bA;
}

model {
   vector[n] p;
   bV ~ normal(0, 0.5);
   bA ~ normal(0, 0.5);
   bP ~ normal(0, 0.5);
   a ~ normal(0, 1.5);
   for (i in 1:n) {
    p[i] = inv_logit(a + (bP * P[i]) + (bV * V[i]) + (bA * A[i]));
   }
   y ~ binomial(sample_size, p);
}

generated quantities {
   vector[n] log_lik;
   vector[n] p;
   for (i in 1:n) {
    p[i] = inv_logit(a + (bP * P[i]) + (bV * V[i]) + (bA * A[i]));
   }
   for (i in 1:n) {
    log_lik[i] = binomial_lpmf(y[i] | sample_size[i], p[i]);
   }
}
