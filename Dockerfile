# ============================================================
# Dockerfile for DSCI 310 Group 04
# Online Shoppers Purchasing Intention Analysis
# ============================================================

# --- BASE IMAGE ---
# We start from a pre-built Jupyter image that already has Python,
# JupyterLab, numpy, scipy, and matplotlib installed.
# The date tag (2025-01-20) pins us to a specific snapshot of the image
# so the environment never changes unexpectedly in the future.
# Using "quay.io" is the recommended registry for jupyter/docker-stacks.
FROM quay.io/jupyter/scipy-notebook:2025-01-20

# --- EXTRA PYTHON PACKAGES ---
# The base image already includes: pandas, scikit-learn, matplotlib,
# seaborn, scipy, and numpy — so we only install what's missing.
# Every version is pinned with == so the environment is 100% reproducible.
# If you ever need a new package, add it here and re-run "docker build".

RUN pip install --no-cache-dir \
    # Loads the dataset directly from UCI ML Repository (avoids manual download)
    ucimlrepo==0.0.7 \
    # Formats tables nicely when printed in the notebook
    tabulate==0.9.0

# --- DEFAULT WORKING DIRECTORY ---
# This sets the folder you land in when the container starts.
# /home/jovyan/work is the standard home directory in Jupyter Docker images.
# The "jovyan" user is the default non-root user in these images.
WORKDIR /home/jovyan/work
