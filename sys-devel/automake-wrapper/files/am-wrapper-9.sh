#!/bin/sh
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/automake-wrapper/files/am-wrapper-9.sh,v 1.1 2013/06/23 04:50:40 vapier Exp $

# Executes the correct automake version.
#
# If WANT_AUTOMAKE is set (can be a whitespace delimited list of versions):
#  - attempt to find an installed version using those
#  - if magic keyword 'latest' is found, pick the latest version that exists
#  - if nothing found, warn, and proceed as if WANT_AUTOMAKE was not set (below)
# If WANT_AUTOMAKE is not set:
#  - Try to detect the version of automake used to generate things (look at
#    Makefile.in and aclocal.m4 and any other useful file)
#  - If detected version is not found, warn and proceed as if blank slate
#  - Try to locate the latest version of automake that exists and run it

(set -o posix) 2>/dev/null && set -o posix

_stderr() { printf 'am-wrapper: %s: %b\n' "${argv0}" "$*" 1>&2; }
warn() { _stderr "warning: $*"; }
err() { _stderr "error: $*"; exit 1; }
unset IFS
which() {
	local p
	IFS=: # we don't use IFS anywhere, so don't bother saving/restoring
	for p in ${PATH} ; do
		p="${p}/$1"
		[ -e "${p}" ] && echo "${p}" && return 0
	done
	unset IFS
	return 1
}

#
# Sanitize argv[0] since it isn't always a full path #385201
#
argv0=${0##*/}
case $0 in
	${argv0})
		# find it in PATH
		if ! full_argv0=$(which "${argv0}") ; then
			err "could not locate ${argv0}; file a bug"
		fi
		;;
	*)
		# re-use full/relative paths
		full_argv0=$0
		;;
esac

if ! seq 0 0 2>/dev/null 1>&2 ; then #338518
	seq() {
		local f l i
		case $# in
			1) f=1 i=1 l=$1;;
			2) f=$1 i=1 l=$2;;
			3) f=$1 i=$2 l=$3;;
		esac
		while :; do
			[ $l -lt $f -a $i -gt 0 ] && break
			[ $f -lt $l -a $i -lt 0 ] && break
			echo $f
			: $(( f += i ))
		done
		return 0
	}
fi

#
# Set up bindings between actual version and WANT_AUTOMAKE;
# Start with last known versions to speed up lookup process.
#
LAST_KNOWN_AUTOMAKE_VER="14"
vers=$(printf '1.%s ' `seq ${LAST_KNOWN_AUTOMAKE_VER} -1 4`)

#
# Helper to scan for a usable program based on version.
#
binary=
all_vers=
find_binary() {
	local v
	all_vers="${all_vers} $*" # For error messages.
	for v ; do
		if [ -x "${full_argv0}-${v}" ] ; then
			binary="${full_argv0}-${v}"
			binary_ver=${v}
			return 0
		fi
	done
	return 1
}

#
# Try and find a usable automake version.  First check the WANT_AUTOMAKE
# setting (whitespace delimited list), then fallback to the latest.
#
find_latest() {
	if ! find_binary ${vers} ; then
		# Brute force it.
		find_binary $(printf '1.%s ' `seq 99 -1 ${LAST_KNOWN_AUTOMAKE_VER}`)
	fi
}
for wx in ${WANT_AUTOMAKE:-latest} ; do
	if [ "${wx}" = "latest" ] ; then
		find_latest && break
	else
		find_binary ${wx} && break
	fi
done

if [ -z "${binary}" ] && [ -n "${WANT_AUTOMAKE}" ] ; then
	warn "could not locate installed version for WANT_AUTOMAKE='${WANT_AUTOMAKE}'; ignoring"
	unset WANT_AUTOMAKE
	find_latest
fi

if [ -z "${binary}" ] ; then
	err "Unable to locate any usuable version of automake.\n" \
	    "\tI tried these versions:${all_vers}\n" \
	    "\tWith a base name of '${full_argv0}'."
fi

#
# autodetect helpers
#
do_awk() {
	local file=$1 ; shift
	local v=$(awk -v regex="$*" '{
		if (ret = match($0, regex)) {
			s = substr($0, ret, RLENGTH)
			ret = match(s, "[0-9]\\.[0-9]+")
			print substr(s, ret, RLENGTH)
			exit
		}
		}' "${file}")
	case " ${auto_vers} " in
	*" ${v} "*) ;;
	*) auto_vers="${auto_vers:+${auto_vers} }${v}" ;;
	esac
}

#
# autodetect routine
#
if [ -z "${WANT_AUTOMAKE}" ] ; then
	auto_vers=
	if [ -r "Makefile.in" ] ; then
		do_awk Makefile.in '^# Makefile.in generated (automatically )?by automake [0-9]\\.[0-9]+'
	fi
	if [ -r "aclocal.m4" ] ; then
		do_awk aclocal.m4 'generated automatically by aclocal [0-9]\\.[0-9]+'
		do_awk aclocal.m4 '[[:space:]]*\\[?AM_AUTOMAKE_VERSION\\(\\[?[0-9]\\.[0-9]+[^)]*\\]?\\)'
	fi
	# We don't need to set $binary here as it has already been setup for us
	# earlier to the latest available version.
	if [ -n "${auto_vers}" ] ; then
		if ! find_binary ${auto_vers} ; then
			warn "auto-detected versions not found (${auto_vers}); falling back to latest available"
		fi
	fi
fi

if [ -n "${WANT_AMWRAPPER_DEBUG}" ] ; then
	if [ -n "${WANT_AUTOMAKE}" ] ; then
		warn "DEBUG: WANT_AUTOMAKE is set to ${WANT_AUTOMAKE}"
	fi
	warn "DEBUG: will execute <${binary}>"
fi

#
# for further consistency
#
export WANT_AUTOMAKE="${binary_ver}"

#
# Now try to run the binary
#
if [ ! -x "${binary}" ] ; then
	# this shouldn't happen
	err "${binary} is missing or not executable.\n" \
	    "\tPlease try installing the correct version of automake."
fi

exec "${binary}" "$@"
# The shell will error out if `exec` failed.
