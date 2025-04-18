#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/openssl-i586                           #
###################################################################

##################################################################
# Required .tcz to be able to build the openssl libraries for i586
##################################################################

tce-load -wi cmake.tcz compiletc.tcz gcc.tcz git.tcz zlib_base-dev.tcz openssl-dev.tcz openssl.tcz curl.tcz ninja.tcz perl5.tcz python3.9.tcz

