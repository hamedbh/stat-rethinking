p_grid <- seq(from = 0,
              to = 1,
              length.out = 1000)
prior <- rep(1 , 1000)

likelihood <- dbinom(6, size = 9 , prob = p_grid)
posterior <- likelihood * prior
posterior <- posterior / sum(posterior)
set.seed(2103L)
samples <- sample(x = p_grid, size = 1e4, replace = TRUE, prob = posterior)
plot(samples)
library(rethinking)
dens(samples)
sum(posterior[p_grid < 0.5])
sum(samples < 0.5)/length(samples)
sum(samples > 0.5 & samples < 0.75)/length(samples)
quantile(samples, 0.8)
quantile(samples, c(0.1, 0.9))

p_grid <- seq(from = 0 ,
              to = 1 ,
              length.out = 1000)
prior <- rep(1, 1000)
likelihood <- dbinom(3 , size = 3 , prob = p_grid)
posterior <- likelihood * prior
posterior <- posterior / sum(posterior)
set.seed(2103L)
samples <-
    sample(p_grid ,
           size = 1e4 ,
           replace = TRUE ,
           prob = posterior)
PI(samples, prob = .5)
HPDI(samples, prob = .5)

sum(posterior * abs( 0.5 - p_grid ))
loss <- sapply(p_grid, function(d) sum(posterior * (abs(d - p_grid))))
plot(loss)
p_grid[which.min(loss)]
median(samples)
