#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/openssl-i586                           #
###################################################################

##################################################################
# Build openssl for i586 including libssl.so.x and libcrypto.so.x
# (where x is the major number in the $OPENSSL_VERSION)
# Those libraries are used by openssl-i586. See
# https://github.com/linic/tcl-core-openssl-i586 for more details.
##################################################################

PARAMETER_ERROR_MESSAGE="ARCHITECTURE OPENSSL_VERSION TCL_VERSION are required. For example: ./build.sh x86 3.0.16 16.x"
if [ ! $# -eq 3 ]; then
  echo $PARAMETER_ERROR_MESSAGE
  exit 1
fi
ARCHITECTURE=$1
if [ $ARCHITECTURE != "x86" ]; then
  echo "ARCHITECTURE can only be x86 for now."
  exit 2
fi
OPENSSL_VERSION=$2
TCL_VERSION=$3
OPENSSL_LIB_SUFFIX=`echo $OPENSSL_VERSION | cut -d '.' -f 1`

if [ ! -f docker-compose.yml ] || ! grep -q "$OPENSSL_VERSION" docker-compose.yml || ! grep -q "$TCL_VERSION" docker-compose.yml; then
  echo "Did not find $OPENSSL_VERSION in docker-compose.yml. Rewriting docker-compose.yml."
  echo "services:\n"\
    " main:\n"\
    "   build:\n"\
    "     context: .\n"\
    "     args:\n"\
    "       - ARCHITECTURE=$ARCHITECTURE\n"\
    "       - OPENSSL_VERSION=$OPENSSL_VERSION\n"\
    "       - TCL_VERSION=$TCL_VERSION\n"\
    "     tags:\n"\
    "       - linichotmailca/openssl-i586:$OPENSSL_VERSION\n"\
    "       - linichotmailca/openssl-i586:latest\n"\
    "     dockerfile: Dockerfile\n" > docker-compose.yml
fi

if sudo docker compose --progress=plain -f docker-compose.yml build; then
  echo "Build succeeded."
else
  echo "Build failed!"
  exit 3
fi
sudo docker compose --progress=plain -f docker-compose.yml up --detach
mkdir -p ./release/$OPENSSL_VERSION/
sudo docker cp openssl-i586-main-1:/home/tc/openssl-$OPENSSL_VERSION/libssl.so.$OPENSSL_LIB_SUFFIX  ./release/$OPENSSL_VERSION/
sudo docker cp openssl-i586-main-1:/home/tc/openssl-$OPENSSL_VERSION/libcrypto.so.$OPENSSL_LIB_SUFFIX  ./release/$OPENSSL_VERSION/
sha512sum ./release/$OPENSSL_VERSION/libssl.so.$OPENSSL_LIB_SUFFIX > ./release/$OPENSSL_VERSION/libssl.so.$OPENSSL_LIB_SUFFIX.sha512.txt
sha512sum ./release/$OPENSSL_VERSION/libcrypto.so.$OPENSSL_LIB_SUFFIX > ./release/$OPENSSL_VERSION/libcrypto.so.$OPENSSL_LIB_SUFFIX.sha512.txt
md5sum ./release/$OPENSSL_VERSION/libssl.so.$OPENSSL_LIB_SUFFIX > ./release/$OPENSSL_VERSION/libssl.so.$OPENSSL_LIB_SUFFIX.md5.txt
md5sum ./release/$OPENSSL_VERSION/libcrypto.so.$OPENSSL_LIB_SUFFIX > ./release/$OPENSSL_VERSION/libcrypto.so.$OPENSSL_LIB_SUFFIX.md5.txt
gpg --detach-sign ./release/$OPENSSL_VERSION/libssl.so.$OPENSSL_LIB_SUFFIX
gpg --detach-sign ./release/$OPENSSL_VERSION/libcrypto.so.$OPENSSL_LIB_SUFFIX

