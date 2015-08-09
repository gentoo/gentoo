#!/bin/bash
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# people who were here:
# (drobbins, 06 Jun 2003)
# (solar, Jul 2004)
# (vapier, Aug 2004)
# (compnerd, Nov 2004)
# (wolf31o2, Jan 2005)
# (azarah, Mar 2005)
# (uberlord, May 2007)
# (kumba, May 2007)
# (williamh, Mar 2014)
# (kumba, Feb 2015)

# sanity check
[[ -e /etc/profile ]] && . /etc/profile

if [[ -e /lib/gentoo/functions.sh ]] ; then
	source /lib/gentoo/functions.sh
	elif [[ -e /etc/init.d/functions.sh ]] ; then
	source /etc/init.d/functions.sh
else
	eerror() { echo "!!! $*"; }
	einfo() { echo "* $*"; }
fi

# Use our own custom script, else logger cause things to
# 'freeze' if we do not have a system logger running
esyslog() {
	:
}

show_status() {
	local num=$1
	shift
	echo "  [[ ($num/3) $* ]]"
}

# Track progress of the bootstrap process to allow for
# semi-transparent resuming
progressfile=/var/run/bootstrap-progress
[[ -e ${progressfile} ]] && source ${progressfile}
export BOOTSTRAP_STAGE=${BOOTSTRAP_STAGE:-1}

set_bootstrap_stage() {
	[[ -z ${STRAP_RUN} ]] && return 0
	export BOOTSTRAP_STAGE=$1
	echo "BOOTSTRAP_STAGE=$1" > ${progressfile}
}

v_echo() {
	einfo "Executing: $*"
	env "$@"
}

cvsver="$Id$"
cvsver=${cvsver##*,v }
cvsver=${cvsver%%Exp*}
cvsyear=${cvsver#* }
cvsyear=${cvsyear%%/*}

usage() {
	echo -e "Usage: ${HILITE}${0##*/}${NORMAL} ${GOOD}[options]${NORMAL}"
	echo -e "  ${GOOD}--debug (-d)${NORMAL}     Run with debug information turned on"
	echo -e "  ${GOOD}--fetchonly (-f)${NORMAL} Just download all the source files"
	echo -e "  ${GOOD}--info (-i)${NORMAL}      Show system related information"
	echo -e "  ${GOOD}--pretend (-p)${NORMAL}   Display the packages that will be merged"
	echo -e "  ${GOOD}--quiet (-q)${NORMAL}     Reduced or condensed output from portage's displays."
	echo -e "  ${GOOD}--tree (-t)${NORMAL}      Display the dependency tree, forces -p"
	echo -e "  ${GOOD}--resume (-r)${NORMAL}    Build/use binary packages"
}

STRAP_EMERGE_OPTS="--oneshot"
STRAP_RUN=1
V_ECHO=env
DEBUG=0

for opt in "$@" ; do
	case ${opt} in
		--fetchonly|-f)
			echo "Running in fetch-only mode ..."
			STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} -f"
			unset STRAP_RUN;;
		--help|-h)
			usage
			exit 0;;
		--debug|-d)   STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} --debug"; DEBUG=1;;
		--info|-i)    STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} --info" ; unset STRAP_RUN ;;
		--pretend|-p) STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} -p"     ; unset STRAP_RUN ;;
		--quiet|-q)   STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} -q"     ; unset STRAP_RUN ;;
		--tree|-t)    STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} -p -t"  ; unset STRAP_RUN ;;
		--resume|-r)  STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} --usepkg --buildpkg";;
		--verbose|-v) STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} -v"; V_ECHO=v_echo;;
		--version|-V)
			einfo "Gentoo Linux bootstrap ${cvsver}"
			exit 0
			;;
		*)
			eerror "Unknown option '${opt}'"
			usage
			exit 1;;
	esac
done

RESUME=0
if [[ -n ${STRAP_RUN} ]]  ; then
	if [ ${BOOTSTRAP_STAGE} -ge 3 ] ; then
		echo
		einfo "System has been bootstrapped already!"
		einfo "If you re-bootstrap the system, you must complete the entire bootstrap process"
		einfo "otherwise you will have a broken system."
		einfo "Press enter to continue or CTRL+C to abort ..."
		read
		set_bootstrap_stage 1
	elif [ ${BOOTSTRAP_STAGE} -gt 1 ] ; then
		einfo "Resuming bootstrap at internal stage #${BOOTSTRAP_STAGE} ..."
		RESUME=1
	fi
else
	export BOOTSTRAP_STAGE=0
fi

for p in /etc/portage /etc ; do
	p+="/make.profile"
	[[ -e ${p} ]] || continue
	if type -P realpath >/dev/null ; then
		MYPROFILEDIR=$(realpath ${p})
	else
		MYPROFILEDIR=$(readlink -f ${p})
	fi
done
if [[ ! -d ${MYPROFILEDIR} ]] ; then
	eerror "Error:  '${MYPROFILEDIR}' does not exist.  Exiting."
	exit 1
fi

echo -e "\n${GOOD}Gentoo Linux; ${BRACKET}http://www.gentoo.org/${NORMAL}"
echo -e "Copyright 1999-${cvsyear} Gentoo Foundation; Distributed under the GPLv2"
if [[ " ${STRAP_EMERGE_OPTS} " == *" -f "* ]] ; then
	echo "Fetching all bootstrap-related archives ..."
elif [[ -n ${STRAP_RUN} ]] ; then
	if [ ${BOOTSTRAP_STAGE} -gt 2 ] ; then
		echo "Resuming Bootstrap of base system ..."
	else
		echo "Starting Bootstrap of base system ..."
	fi
fi
echo -------------------------------------------------------------------------------
show_status 0 Locating packages

# This should not be set to get glibc to build properly. See bug #7652.
unset LD_LIBRARY_PATH

# We do not want stray $TMP, $TMPDIR or $TEMP settings
unset TMP TMPDIR TEMP

cleanup() {
	if [[ -n ${STRAP_RUN} ]] ; then
		if [ ${BOOTSTRAP_STAGE} -le 2 ] ; then
			cp -f /var/cache/edb/mtimedb /var/run/bootstrap-mtimedb
		else
			rm -f /var/run/bootstrap-mtimedb
		fi
	fi
	exit $1
}

pycmd() {
	[[ ${DEBUG} = "1" ]] && echo /usr/bin/python -c "$@" > /dev/stderr
	/usr/bin/python -c "$@"
}

# TSTP messes ^Z of bootstrap up, so we don't trap it anymore.
trap "cleanup" TERM KILL INT QUIT ABRT

# Bug #50158 (don't use `which` in a bootstrap).
if ! type -path portageq &>/dev/null ; then
	echo -------------------------------------------------------------------------------
	eerror "Your portage version is too old.  Please use a newer stage1 image."
	echo
	cleanup 1
fi

# USE may be set from the environment so we back it up for later.
export ORIGUSE=$(portageq envvar USE)

# Check for 'build' or 'bootstrap' in USE ...
INVALID_USE=$(gawk -v ORIGUSE="${ORIGUSE}" '
	BEGIN { 
		if (ORIGUSE ~ /[[:space:]](build|bootstrap)[[:space:]]/)
			print "yes"
	}')

# Do not do the check for stage build scripts ...
if [[ ${INVALID_USE} = "yes" ]] ; then
	echo
	eerror "You have 'build' or 'bootstrap' in your USE flags. Please"
	eerror "remove it before trying to continue, since these USE flags"
	eerror "are used for internal purposes and shouldn't be specified"
	eerror "by you."
	echo
	cleanup 1
fi

# since our logic here ignores stuff found in package.use, let's warn the
# user so they can avert disaster early
if [[ -n $(sed -n '/^[ 	]*#/d;/^[ 	]*$/d;p' /etc/portage/package.use 2>/dev/null) ]] ; then
	echo
	ewarn "You appear to have custom USE flags set in /etc/portage/package.use."
	ewarn "Be aware that these settings may be ignored while running this script"
	ewarn "(due to limitations in the bootstrap process).  If you have some USE"
	ewarn "flags you wish to apply to say gcc or glibc, you should hit CTRL+C"
	ewarn "now, export them in your environment (see below), and then restart."
	ewarn " # export USE='some flags i want'"
fi

# gettext should only be needed when used with nls
for opt in ${ORIGUSE} ; do
	case "${opt}" in
		bindist)
			ALLOWED_USE="${ALLOWED_USE} bindist"
			;;
		nls)
			USE_NLS=1
			ALLOWED_USE="${ALLOWED_USE} nls"
			;;
		nptl)
			export MYARCH=$(portageq envvar ARCH)
 			if [[ -z $(portageq best_visible / '>=sys-kernel/linux-headers-2.6.0') ]] ; then
				eerror "You need to have >=sys-kernel/linux-headers-2.6.0 unmasked!"
				eerror "Please edit the latest >=sys-kernel/linux-headers-2.6.0 package,"
				eerror "and add your ARCH to KEYWORDS or change your make.profile link"
				eerror "to a profile which does not have 2.6 headers masked."
				echo
				cleanup 1
			fi
			USE_NPTL=1
			;;
		nptlonly)
			USE_NPTLONLY=1
			;;
		multilib)
			ALLOWED_USE="${ALLOWED_USE} multilib"
			;;
		userlocales)
			ALLOWED_USE="${ALLOWED_USE} userlocales"
			;;
	esac
done

# With cascading profiles, the packages profile at the leaf is not a
# complete system, just the restrictions to it for the specific profile.
# The complete profile consists of an aggregate of the leaf and all its
# parents.  So we now call portage to read the aggregate profile and store
# that into a variable.

eval $(pycmd '
import portage
import sys
for atom in portage.settings.packages:
	if not isinstance(atom, portage.dep.Atom):
		atom = portage.dep.Atom(atom.lstrip("*"))
	varname = "my" + portage.catsplit(atom.cp)[1].upper().replace("-", "_")
	sys.stdout.write("%s=\"%s\"; " % (varname, atom))
')

# This stuff should never fail but will if not enough is installed.
[[ -z ${myBASELAYOUT} ]] && myBASELAYOUT=">=$(portageq best_version / sys-apps/baselayout)"
[[ -z ${myPORTAGE}    ]] && myPORTAGE="portage"
[[ -z ${myBINUTILS}   ]] && myBINUTILS="binutils"
[[ -z ${myGCC}        ]] && myGCC="gcc"
[[ -z ${myGETTEXT}    ]] && myGETTEXT="gettext"
[[ -z ${myLIBC}       ]] && myLIBC="virtual/libc"
[[ -z ${myTEXINFO}    ]] && myTEXINFO="sys-apps/texinfo"
[[ -z ${myZLIB}       ]] && myZLIB="zlib"
[[ -z ${myNCURSES}    ]] && myNCURSES="ncurses"

# Do we really want gettext/nls?
[[ ${USE_NLS} != 1 ]] && myGETTEXT=

# Do we really have no 2.4.x nptl kernels in portage?
if [[ ${USE_NPTL} = "1" ]] ; then
	myOS_HEADERS="$(portageq best_visible / '>=sys-kernel/linux-headers-2.6.0')"
	[[ -n ${myOS_HEADERS} ]] && myOS_HEADERS=">=${myOS_HEADERS}"
	ALLOWED_USE="${ALLOWED_USE} nptl"
	# Should we build with nptl only?
	[[ ${USE_NPTLONLY} = "1" ]] && ALLOWED_USE="${ALLOWED_USE} nptlonly"
fi
[[ -z ${myOS_HEADERS} ]] && myOS_HEADERS="virtual/os-headers"

einfo "Using baselayout : ${myBASELAYOUT}"
einfo "Using portage    : ${myPORTAGE}"
einfo "Using os-headers : ${myOS_HEADERS}"
einfo "Using binutils   : ${myBINUTILS}"
einfo "Using gcc        : ${myGCC}"
[[ ${USE_NLS} = "1" ]] && einfo "Using gettext    : ${myGETTEXT}"
einfo "Using libc       : ${myLIBC}"
einfo "Using texinfo    : ${myTEXINFO}"
einfo "Using zlib       : ${myZLIB}"
einfo "Using ncurses    : ${myNCURSES}"
echo -------------------------------------------------------------------------------
show_status 1 Configuring environment
echo -------------------------------------------------------------------------------

[[ -x /usr/sbin/gcc-config ]] && GCC_CONFIG="/usr/sbin/gcc-config"
[[ -x /usr/bin/gcc-config  ]] && GCC_CONFIG="/usr/bin/gcc-config"

# Allow portage to overwrite stuff
export CONFIG_PROTECT="-*"

# disable collision-protection
export FEATURES="${FEATURES} -collision-protect"

# query BOOTSTRAP_USE from the profile
BOOTSTRAP_USE=$(portageq envvar BOOTSTRAP_USE)

if [ ${BOOTSTRAP_STAGE} -le 1 ] ; then
	show_status 2 Updating portage
	${V_ECHO} USE="-* build bootstrap ${ALLOWED_USE} ${BOOTSTRAP_USE}" emerge ${STRAP_EMERGE_OPTS} ${myPORTAGE} || cleanup 1
	echo -------------------------------------------------------------------------------
	set_bootstrap_stage 2
fi
export USE="-* bootstrap ${ALLOWED_USE} ${BOOTSTRAP_USE}"

# We can't unmerge headers which may or may not exist yet. If your
# trying to use nptl, it may be needed to flush out any old headers
# before fully bootstrapping. 
if [ ${BOOTSTRAP_STAGE} -le 2 ] ; then
	show_status 3 Emerging packages
	if [[ ${RESUME} -eq 1 ]] ; then
		STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} --resume"
		cp /var/run/bootstrap-mtimedb /var/cache/edb
	else
		STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} \
			${myOS_HEADERS} ${myTEXINFO} ${myGETTEXT} ${myBINUTILS} \
			${myGCC} ${myLIBC} ${myBASELAYOUT} ${myZLIB}"
	fi
	${V_ECHO} emerge ${STRAP_EMERGE_OPTS} || cleanup 1
	echo -------------------------------------------------------------------------------
	set_bootstrap_stage 3
fi

# Basic support for gcc multi version/arch scheme ...
if [[ -n ${STRAP_RUN} ]] ; then
	if [[ -x ${GCC_CONFIG} ]] && ${GCC_CONFIG} --get-current-profile &>/dev/null
	then
		# Make sure we get the old gcc unmerged ...
		emerge --prune sys-devel/gcc || cleanup 1
		# Make sure the profile and /lib/cpp and /usr/bin/cc are valid ...
		${GCC_CONFIG} "$(${GCC_CONFIG} --get-current-profile)" &>/dev/null
	fi
fi

if [[ -n ${STRAP_RUN} ]] ; then
	echo -------------------------------------------------------------------------------
	einfo "Please note that you should now add the '-e' option for emerge system:"
	echo
	einfo "  # emerge -e system"
	echo
fi

cleanup 0
