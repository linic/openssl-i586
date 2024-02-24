# NOTE: Copied from https://www.openssl.org/source/ 
# "[OpenSSL] versions (including 1.1.1, 1.1.0, 1.0.2, 1.0.0 and 0.9.8) are now out of support and 
# should not be used"
FROM debian:latest
ARG OPENSSL_VERSION=1.1.1o
WORKDIR /tmp/
RUN apt update
RUN apt dist-upgrade
RUN dpkg --add-architecture i386
RUN apt update
COPY apt_packages.txt .
RUN xargs apt install --yes < apt_packages.txt
WORKDIR /
RUN wget https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
RUN tar -zxvf openssl-$OPENSSL_VERSION.tar.gz
WORKDIR openssl-$OPENSSL_VERSION
ENV CFLAGS="-march=pentium"
ENV CXXFLAGS="-march=pentium"
RUN ./Configure linux-x86
RUN make
# If you docker compose build you'll be able to docker exec -it into it and move around or
# docker cp files out of it.
COPY echo_sleep /
RUN chmod +x /echo_sleep
ENTRYPOINT ["/bin/bash", "/echo_sleep"]

