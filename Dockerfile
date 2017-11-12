FROM debian:stretch 
MAINTAINER Kaya Kupferschmidt <k.kupferschmidt@dimajix.de> 

ARG ANACONDA_VERSION=4.3.30

ENV ANACONDA_HOME=/opt/anaconda3

# install nodejs, utf8 locale, set CDN because default httpredir is unreliable 
ENV DEBIAN_FRONTEND noninteractive 
RUN REPO=http://cdn-fastly.deb.debian.org && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install wget locales git bzip2 libtemplate-perl &&\
    /usr/sbin/update-locale LANG=C.UTF-8 && \
    locale-gen C.UTF-8 && \
    apt-get remove -y locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Users with other locales should set this in their derivative image
ENV LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8 \
    LC_ALL=C.UTF-8

# install Python with conda 
RUN wget -q https://repo.continuum.io/miniconda/Miniconda3-${ANACONDA_VERSION}-Linux-x86_64.sh -O /tmp/miniconda.sh  && \
    bash /tmp/miniconda.sh -f -b -p ${ANACONDA_HOME} && \
    ${ANACONDA_HOME}/bin/pip install --upgrade pip && \
    rm /tmp/miniconda.sh
ENV PATH=${ANACONDA_HOME}/bin:/opt/docker/bin:$PATH

# copy configs and binaries
COPY libexec/ /opt/docker/libexec/
COPY bin/ /opt/docker/bin/

