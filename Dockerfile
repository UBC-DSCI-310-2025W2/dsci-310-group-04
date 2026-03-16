FROM rocker/rstudio:4.5.3

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libwebp-dev \
    && apt-get clean

# Install quarto
RUN curl -o quarto.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.27/quarto-1.8.27-linux-amd64.deb  && \
    dpkg -i quarto.deb && \
    rm quarto.deb

RUN mkdir -p /home/rstudio/work && chown rstudio:rstudio /home/rstudio/work

# Set working directory
WORKDIR /home/rstudio/work

# Install TinyTeX
RUN quarto install tinytex

# Copy renv lockfile and restore R packages
COPY --chown=rstudio:rstudio renv.lock .

RUN Rscript -e "install.packages('renv', repos='https://cloud.r-project.org')" && \
    Rscript -e "renv::restore(lockfile='/home/rstudio/work/renv.lock', repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/noble/latest'), prompt=FALSE)"

# Copy the analysis notebook into the image
COPY --chown=rstudio:rstudio . .

# Render the quarto report 
CMD ["/init"]