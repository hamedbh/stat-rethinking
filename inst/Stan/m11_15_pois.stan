data {
   int n;
   array[n] int admit;
   array[n] int rej;
}

parameters {
   array[2] real a;
}

transformed parameters {
   array[2] real lambda;
   lambda = exp(a);
}

model {
   a ~ normal(0, 1.5);
   admit ~ poisson(lambda[1]);
   rej ~ poisson(lambda[2]);
}

generated quantities {
   vector[n] log_lik;
   for (i in 1:n) {
      log_lik[i] = poisson_lpmf(admit[i] | lambda[1]);
   }
}
