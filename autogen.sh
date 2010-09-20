#!/bin/sh
# Run this to generate all the initial makefiles, etc.
set -e

AMFILES=`find -name Makefile.am -printf '%p ' | sed -e 's,\./\([^ ]*\)\.am ,\1 ,g'`

cat configure.ac.stub - > configure.ac <<EOF
AC_CONFIG_FILES([$AMFILES])
AC_OUTPUT
EOF

mkdir -p m4
aclocal
automake --add-missing --include-deps --copy -Wno-portability
autoconf
echo "Now run ./configure (add --help for supported configure options)"
