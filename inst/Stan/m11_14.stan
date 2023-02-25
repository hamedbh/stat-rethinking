data {
    int n; // number of observations
    int k; // number of outcome values
    array[n] int career; // the outcome values to model
    array[n] real family_income; // the predictor
}

parameters {
   vector[k - 1] a;
   vector[k - 1] b;
}

model {
    vector[k] p;
    vector[k] s;
    a ~ normal(0, 1.5);
    b ~ normal(0, 1);
    for (i in 1:n) {
        for (j in 1:(k - 1)) {
            s[j] = a[j] + (b[j] * family_income[i]);
        }
        s[k] = 0; //the pivot, again set to the last category
        p = softmax(s);
        career[i] ~ categorical(p);
    }
}
