ARG TIDYVERSE_TAG

FROM rocker/tidyverse:4.2.2

RUN apt-get update -y && apt-get install -y --no-install-recommends libglpk-dev software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
RUN mkdir -p $HOME/.R/ \
  && mkdir -p $HOME/stat-rethinking \
  && echo "CXX14FLAGS=-O3 -march=native -mtune=native -fPIC" >> $HOME/.R/Makevars \
  && echo "CXX14=g++" >> $HOME/.R/Makevars \
  && echo "rstan::rstan_options(auto_write = TRUE)" >> /home/rstudio/.Rprofile \
  && echo "options(mc.cores = parallel::detectCores())" >> /home/rstudio/.Rprofile

RUN Rscript -e 'Sys.setenv(DOWNLOAD_STATIC_LIBV8 = 1); install.packages("rstan")'

ENV CMDSTAN /usr/share/.cmdstan

RUN cd /usr/share/ \
  && wget --progress=dot:mega https://github.com/stan-dev/cmdstan/releases/download/v2.31.0/cmdstan-2.31.0.tar.gz \
  && tar -zxpf cmdstan-2.31.0.tar.gz && mv cmdstan-2.31.0 .cmdstan \
  && ln -s .cmdstan cmdstan && cd .cmdstan \
  && make build

ENV R_PACKAGES="\
    remotes \
    renv \
"

RUN install2.r --error --skipinstalled $R_PACKAGES

COPY ./rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json

