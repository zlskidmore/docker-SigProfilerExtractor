# work from latest LTS ubuntu release
FROM ubuntu:20.04

# set the environment variables
ENV sigprofilerextractor_version 1.1.4
ENV DEBIAN_FRONTEND="noninteractive"

# run update and install necessary tools ubuntu tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    curl \
    unzip \
    python3 \
    bzip2 \
    libnss-sss \
    python3-pip \
    vim \
    less \
    wget \
    zlib1g-dev \
    libjpeg8-dev

# Install sigProfilerExtractor
WORKDIR /usr/local/bin/

RUN python3 -m pip install -U --force-reinstall pip

RUN wget https://github.com/AlexandrovLab/SigProfilerExtractor/archive/refs/tags/v${sigprofilerextractor_version}.tar.gz
RUN tar -xzvf v${sigprofilerextractor_version}.tar.gz
RUN cd SigProfilerExtractor-${sigprofilerextractor_version} && pip install --no-cache-dir .

# download test data, and reference data
RUN python3 -c "from SigProfilerMatrixGenerator import install as genInstall; genInstall.install('GRCh38'); genInstall.install('GRCh37')"
RUN mkdir -p /opt/testData
WORKDIR /opt/testData
RUN wget  ftp://alexandrovlab-ftp.ucsd.edu/pub/tools/SigProfilerExtractor/Example_data/21BRCA.zip
RUN unzip 21BRCA.zip

