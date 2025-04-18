# Build openssl libraries for i586
ARCHITECTURE=x86
OPENSSL_VERSION=3.0.16
TCL_VERSION=16.x

all: build

build:
	tools/build.sh ${ARCHITECTURE} ${OPENSSL_VERSION} ${TCL_VERSION}

