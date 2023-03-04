data {
   int n;
   array[n] int applications;
   array[n] int admit;
}

parameters {
    real a;
}

model {
   real p;
   a ~ normal(0, 1.5);
   p = inv_logit(a);
   admit ~ binomial(applications, p);
}

generated quantities {
   vector[n] log_lik;
   real p;
   p = inv_logit(a);
   for (i in 1:n) {
    log_lik[i] = binomial_lpmf(admit[i] | applications[i], p);
   }
}
