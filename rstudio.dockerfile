FROM rocker/rstudio

RUN apt update && \
    apt install -y build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev libgit2-dev libfontconfig1-dev \ 
    libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev default-jdk libbz2-dev
