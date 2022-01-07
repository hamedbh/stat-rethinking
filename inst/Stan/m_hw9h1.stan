data {
  real y;
}

parameters {
  real a;
  real b;
}

model {
  a ~ normal(0, 1);
  b ~ cauchy(0, 1); 
}

