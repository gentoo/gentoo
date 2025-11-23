#!/bin/sh
#
# This script extracts the version from the project header file
#
project=$1
if [ ! -f include/$project.h ]; then
    echo "version.sh: error: include/$project.h does not exist" 1>&2
    exit 1
fi
MAJOR=`egrep '^#define .*_VERSION_MAJOR +[0-9]+$' include/$project.h`
MINOR=`egrep '^#define .*_VERSION_MINOR +[0-9]+$' include/$project.h`
PATCH=`egrep '^#define .*_VERSION_PATCH +[0-9]+$' include/$project.h`
if [ -z "$MAJOR" -o -z "$MINOR" -o -z "$PATCH" ]; then
    echo "version.sh: error: could not extract version from include/$project.h" 1>&2
    exit 1
fi
MAJOR=`echo $MAJOR | awk '{ print $3 }'`
MINOR=`echo $MINOR | awk '{ print $3 }'`
PATCH=`echo $PATCH | awk '{ print $3 }'`
echo $MAJOR.$MINOR.$PATCH | tr -d '\n'

