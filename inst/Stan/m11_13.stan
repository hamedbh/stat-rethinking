data {
  int N; 
  int K; 
  int career[N]; 
  int income[K]; 
}

parameters {
  vector[K - 1] a; // intercepts
  real<lower=0> b; // coefficient beta that associates income with career
}

model {
  vector[K] p; 
  vector [K] s; 
  a ~ normal(0, 1); 
  b ~ normal(0, 0.5); 
  s[1] = a[1] + (b * income[1]); 
  s[2] = a[2] + (b * income[2]); 
  s[3] = 0; // pivot
  p = softmax(s); 
  career ~ categorical(p); 
}
