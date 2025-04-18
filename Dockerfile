ARG ARCHITECTURE
ARG OPENSSL_VERSION
ARG TCL_VERSION
FROM linichotmailca/tcl-core-x86:$TCL_VERSION-$ARCHITECTURE
ARG OPENSSL_VERSION
WORKDIR /home/tc/tools/
COPY --chown=tc:staff tools/tce-load-build-requirements.sh .
RUN ./tce-load-build-requirements.sh
WORKDIR /home/tc/
RUN wget https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
RUN tar -zxvf openssl-$OPENSSL_VERSION.tar.gz
WORKDIR /home/tc/openssl-$OPENSSL_VERSION
ENV CFLAGS="-march=pentium"
ENV CXXFLAGS="-march=pentium"
RUN ./Configure linux-x86
RUN make
# If you docker compose build you'll be able to docker exec -it into it and move around or
# docker cp files out of it.
COPY --chown=tc:staff tools/echo_sleep.sh /home/tc/tools/
ENTRYPOINT ["/bin/sh", "/home/tc/tools/echo_sleep.sh"]

