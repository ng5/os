#!/usr/bin/env bash
curl -s https://raw.githubusercontent.com/ng5/os/main/debian_setup_minimal.sh | bash
apt install -y autoconf automake build-essential clang clang-format cryptsetup libblas-dev libcurl4-openssl-dev libgmp-dev liblapack-dev libmpfr-dev libssl-dev libtool llvm openjdk-11-jdk zlib1g-dev
