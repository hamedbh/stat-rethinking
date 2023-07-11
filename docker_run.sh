# the location of the renv cache on the host machine
RENV_PATHS_CACHE_HOST=/home/hamedbh/.cache/R/renv/cache

# where the cache should be mounted in the container
RENV_PATHS_CACHE_CONTAINER=/home/rstudio/.cache/R/renv/cache

docker run --rm -ti \
  -e PASSWORD=secret \
	-e "RENV_PATHS_CACHE=${RENV_PATHS_CACHE_CONTAINER}" \
	-v "${RENV_PATHS_CACHE_HOST}:${RENV_PATHS_CACHE_CONTAINER}" \
	-v $(pwd):/home/rstudio/stat-rethinking \
	-e DISABLE_AUTH=true \
	-e ROOT=true \
	-p 8787:8787 \
	hamedbh/stat-rethinking
