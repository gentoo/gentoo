#!/bin/sh
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

usage() {
cat << "USAGE_END"
Usage: fix_libtool_files.sh <old-gcc-version> [--oldarch <old-CHOST>]

    Where <old-gcc-version> is the version number of the
    previous gcc version.  For example, if you updated to
    gcc-3.2.1, and you had gcc-3.2 installed, run:

      # fix_libtool_files.sh 3.2

    If you updated to gcc-3.2.3, and the old CHOST was i586-pc-linux-gnu
    but you now have CHOST as i686-pc-linux-gnu, run:

      # fix_libtool_files.sh 3.2 --oldarch i586-pc-linux-gnu

    Note that if only the CHOST and not the version changed, you can run
    it with the current version and the '--oldarch <old-CHOST>' arguments,
    and it will do the expected:

      # fix_libtool_files.sh `gcc -dumpversion` --oldarch i586-pc-linux-gnu

USAGE_END
	exit 1
}

case $2 in
--oldarch) [ $# -ne 3 ] && usage ;;
*)         [ $# -ne 1 ] && usage ;;
esac

ARGV1=$1
ARGV2=$2
ARGV3=$3

. /etc/profile || exit 1

if [ ${EUID:-0} -ne 0 ] ; then
	echo "${0##*/}: Must be root."
	exit 1
fi

# make sure the files come out sane
umask 0022

OLDCHOST=
[ "${ARGV2}" = "--oldarch" ] && OLDCHOST=${ARGV3}

AWKDIR="/usr/share/gcc-data"

if [ ! -r "${AWKDIR}/fixlafiles.awk" ] ; then
	echo "${0##*/}: ${AWKDIR}/fixlafiles.awk does not exist!"
	exit 1
fi

OLDVER=${ARGV1}

export OLDVER OLDCHOST

echo "Scanning libtool files for hardcoded gcc library paths..."
exec gawk -f "${AWKDIR}/fixlafiles.awk"

# vim:ts=4
