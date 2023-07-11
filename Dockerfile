FROM rocker/tidyverse:4.3.1

# System dependencies
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
  libglpk-dev \
  libxml2 \
  libxml2-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Make RStudio look how I want it to
COPY rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json

# Install the required, specific version of {renv}
ENV RSTUDIO_HOME=/home/rstudio
WORKDIR ${RSTUDIO_HOME}
ENV RENV_VERSION=0.17.3
RUN sudo -u rstudio R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN sudo -u rstudio R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

# cmdstan
ENV CMDSTAN_VERSION=2.32.2
RUN cd /usr/share/ \
  && wget --progress=dot:mega https://github.com/stan-dev/cmdstan/releases/download/v${CMDSTAN_VERSION}/cmdstan-${CMDSTAN_VERSION}.tar.gz \
  && tar -zxpf cmdstan-${CMDSTAN_VERSION}.tar.gz && mv cmdstan-${CMDSTAN_VERSION} .cmdstan \
  && ln -s .cmdstan cmdstan && cd .cmdstan \
  && make build

ENV CMDSTAN=/usr/share/.cmdstan

# install {rstan} with Makevars and good options
RUN mkdir -p $HOME/.R/ \
  && echo "CXX14FLAGS=-O3 -march=native -mtune=native -fPIC" >> $HOME/.R/Makevars \
  && echo "CXX14=g++" >> $HOME/.R/Makevars \
  && mkdir -p ${RSTUDIO_HOME}/.R \
  && cp $HOME/.R/Makevars ${RSTUDIO_HOME}/.R/Makevars \
  && Rscript -e 'Sys.setenv(DOWNLOAD_STATIC_LIBV8 = 1);install.packages("V8");install.packages("rstan")' \
  && echo "rstan::rstan_options(auto_write = TRUE)" >> ${RSTUDIO_HOME}/.Rprofile \
  && echo "options(mc.cores = parallel::detectCores())" >> ${RSTUDIO_HOME}/.Rprofile

# Script to restore project after startup
COPY set_owner.sh /home/rstudio/set_owner.sh

# Set up the project directory with {renv} files
ENV PROJECT_DIR=/home/rstudio/stat-rethinking 
WORKDIR ${PROJECT_DIR}
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json
COPY renv.lock renv.lock
# Other project files
COPY stat-rethinking.Rproj stat-rethinking.Rproj
# Give the right ownership
RUN chown -R rstudio /home/rstudio

## TODO
# - move this to stat rethinking project
# - check whether I need to install quarto separately (SEEMS NOT)
# - consider switching to clang? (LEAVE IT FOR NOW, NOT WORTH THE FAFF UNTIL I GET THIS WORKING WITH MY stat rethinking PROJECT)
#> # A tibble: 1 × 13
#>   expression      min   median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time result     memory               time           gc              
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm> <list>     <list>               <list>         <list>          
#> 1 gcc           7.42s    7.42s     0.135    1.15MB        0     1     0      7.42s <CmdStnMd> <Rprofmem [722 × 3]> <bench_tm [1]> <tibble [1 × 3]>
