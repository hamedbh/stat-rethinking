ARG TIDYVERSE_TAG

FROM rocker/tidyverse:4.2.2

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    libglpk-dev \
    libxml2 \
    libxml2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN cd /usr/share/ \
  && wget --progress=dot:mega https://github.com/stan-dev/cmdstan/releases/download/v2.31.0/cmdstan-2.31.0.tar.gz \
  && tar -zxpf cmdstan-2.31.0.tar.gz && mv cmdstan-2.31.0 .cmdstan \
  && ln -s .cmdstan cmdstan && cd .cmdstan \
  && make build

ENV CMDSTAN /usr/share/.cmdstan

RUN mkdir -p $HOME/.R/ \
  && echo "CXX14FLAGS=-O3 -march=native -mtune=native -fPIC" >> $HOME/.R/Makevars \
  && echo "CXX14=g++" >> $HOME/.R/Makevars \
  && echo "rstan::rstan_options(auto_write = TRUE)" >> /home/rstudio/.Rprofile \
  && echo "options(mc.cores = parallel::detectCores())" >> /home/rstudio/.Rprofile

RUN Rscript -e 'Sys.setenv(DOWNLOAD_STATIC_LIBV8 = 1); install.packages("rstan")'

COPY ./rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json

ENV RENV_VERSION 0.16.0
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"
RUN R -e "install.packages('conflicted')"

WORKDIR /stat-rethinking
COPY renv.lock renv.lock
RUN mkdir -p renv
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.dcf renv/settings.dcf
RUN R -e "renv::restore()"
#ENV R_PACKAGES="\
#    remotes \
#    renv \
#"
#RUN install2.r --error --skipinstalled $R_PACKAGES



