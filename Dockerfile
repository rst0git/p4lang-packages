FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y \
    gpg \
    curl \
    && echo 'deb http://download.opensuse.org/repositories/home:/rstoyanov/xUbuntu_22.04/ /' > /etc/apt/sources.list.d/home:rstoyanov.list \
    && sh -c 'curl -fsSL https://download.opensuse.org/repositories/home:rstoyanov/xUbuntu_22.04/Release.key | gpg --dearmor > /etc/apt/trusted.gpg.d/home_rstoyanov.gpg'

RUN apt-get update -y && apt-get install -y \
    debhelper \
    dh-python \
    git \
    rsync \
    bc \
    bison \
    flex \
    libssl-dev \
    make \
    equivs \
    devscripts

WORKDIR /p4lang-packages

COPY . /p4lang-packages