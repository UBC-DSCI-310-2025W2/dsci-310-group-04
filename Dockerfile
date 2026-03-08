FROM quay.io/jupyter/r-notebook:2025-01-20

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER jovyan

# Copy renv lockfile and restore R packages
COPY --chown=jovyan:users renv.lock /home/jovyan/renv.lock

RUN Rscript -e "install.packages('renv', repos='https://cloud.r-project.org')" && \
    Rscript -e "renv::restore(lockfile='/home/jovyan/renv.lock', repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/noble/latest'), prompt=FALSE)"

# Copy the analysis notebook into the image
COPY --chown=jovyan:users reports/milestone_1/milestone_1.ipynb /home/jovyan/work/

WORKDIR /home/jovyan/work