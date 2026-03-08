FROM quay.io/jupyter/r-notebook:2025-01-20

# Copy renv lockfile and restore R packages
COPY --chown=jovyan:users renv.lock /home/jovyan/renv.lock

RUN Rscript -e "install.packages('renv', repos='https://cloud.r-project.org')" && \
    Rscript -e "renv::restore(lockfile='/home/jovyan/renv.lock', repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/noble/latest'), prompt=FALSE)"

# Copy the analysis notebook into the image
COPY --chown=jovyan:users reports/predicting_online_purchasing_behavior.ipynb /home/jovyan/work/

WORKDIR /home/jovyan/work