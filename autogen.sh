#!/bin/sh
# Run this to generate all the initial makefiles, etc.
set -e

mkdir -p m4
automake --add-missing --include-deps --copy
autoconf
echo Now run ./configure
