FROM quay.io/jupyter/r-notebook:2025-01-20

# Copy renv lockfile and restore R packages
COPY renv.lock /home/jovyan/renv.lock

RUN Rscript -e "install.packages('renv', repos='https://cloud.r-project.org')" && \
    Rscript -e "renv::restore(lockfile='/home/jovyan/renv.lock', prompt=FALSE)"

# Copy the analysis notebook into the image
COPY reports/milestone_1/milestone_1.ipynb /home/jovyan/work/

WORKDIR /home/jovyan/work