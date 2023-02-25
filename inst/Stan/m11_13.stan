data {
  int n;
  int k;
  array[n] int career;
  vector[k] career_income;
}

parameters {
  vector[k - 1] a; // intercepts
  real<lower=0> b; // coefficient beta that associates career_income with career
}

model {
  vector[k] p;
  vector[k] s; 
  a ~ normal(0, 1);
  b ~ normal(0, 0.5);
  s[1] = a[1] + (b * career_income[1]);
  s[2] = a[2] + (b * career_income[2]);
  s[3] = 0; // pivot
  p = softmax(s);
  career ~ categorical(p);
}
