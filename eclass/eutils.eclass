# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: eutils.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: many extra (but common) functions that are used in ebuilds
# @DESCRIPTION:
# The eutils eclass contains a suite of functions that complement
# the ones that ebuild.sh already contain.  The idea is that the functions
# are not required in all ebuilds but enough utilize them to have a common
# home rather than having multiple ebuilds implementing the same thing.
#
# Due to the nature of this eclass, some functions may have maintainers
# different from the overall eclass!

if [[ -z ${_EUTILS_ECLASS} ]]; then
_EUTILS_ECLASS=1

# implicitly inherited (now split) eclasses
case ${EAPI:-0} in
0|1|2|3|4|5|6)
	inherit desktop epatch estack ltprune multilib preserve-libs \
		toolchain-funcs vcs-clean
	;;
esac

# @FUNCTION: emktemp
# @USAGE: [temp dir]
# @DESCRIPTION:
# Cheap replacement for when debianutils (and thus mktemp)
# does not exist on the users system.
emktemp() {
	local exe="touch"
	[[ $1 == -d ]] && exe="mkdir" && shift
	local topdir=$1

	if [[ -z ${topdir} ]] ; then
		[[ -z ${T} ]] \
			&& topdir="/tmp" \
			|| topdir=${T}
	fi

	if ! type -P mktemp > /dev/null ; then
		# system lacks `mktemp` so we have to fake it
		local tmp=/
		while [[ -e ${tmp} ]] ; do
			tmp=${topdir}/tmp.${RANDOM}.${RANDOM}.${RANDOM}
		done
		${exe} "${tmp}" || ${exe} -p "${tmp}"
		echo "${tmp}"
	else
		# the args here will give slightly wierd names on BSD,
		# but should produce a usable file on all userlands
		if [[ ${exe} == "touch" ]] ; then
			TMPDIR="${topdir}" mktemp -t tmp.XXXXXXXXXX
		else
			TMPDIR="${topdir}" mktemp -dt tmp.XXXXXXXXXX
		fi
	fi
}

# @FUNCTION: edos2unix
# @USAGE: <file> [more files ...]
# @DESCRIPTION:
# A handy replacement for dos2unix, recode, fixdos, etc...  This allows you
# to remove all of these text utilities from DEPEND variables because this
# is a script based solution.  Just give it a list of files to convert and
# they will all be changed from the DOS CRLF format to the UNIX LF format.
edos2unix() {
	[[ $# -eq 0 ]] && return 0
	sed -i 's/\r$//' -- "$@" || die
}

# @FUNCTION: strip-linguas
# @USAGE: [<allow LINGUAS>|<-i|-u> <directories of .po files>]
# @DESCRIPTION:
# Make sure that LINGUAS only contains languages that
# a package can support.  The first form allows you to
# specify a list of LINGUAS.  The -i builds a list of po
# files found in all the directories and uses the
# intersection of the lists.  The -u builds a list of po
# files found in all the directories and uses the union
# of the lists.
strip-linguas() {
	local ls newls nols
	if [[ $1 == "-i" ]] || [[ $1 == "-u" ]] ; then
		local op=$1; shift
		ls=$(find "$1" -name '*.po' -exec basename {} .po ';'); shift
		local d f
		for d in "$@" ; do
			if [[ ${op} == "-u" ]] ; then
				newls=${ls}
			else
				newls=""
			fi
			for f in $(find "$d" -name '*.po' -exec basename {} .po ';') ; do
				if [[ ${op} == "-i" ]] ; then
					has ${f} ${ls} && newls="${newls} ${f}"
				else
					has ${f} ${ls} || newls="${newls} ${f}"
				fi
			done
			ls=${newls}
		done
	else
		ls="$@"
	fi

	nols=""
	newls=""
	for f in ${LINGUAS} ; do
		if has ${f} ${ls} ; then
			newls="${newls} ${f}"
		else
			nols="${nols} ${f}"
		fi
	done
	[[ -n ${nols} ]] \
		&& einfo "Sorry, but ${PN} does not support the LINGUAS:" ${nols}
	export LINGUAS=${newls:1}
}

# @FUNCTION: make_wrapper
# @USAGE: <wrapper> <target> [chdir] [libpaths] [installpath]
# @DESCRIPTION:
# Create a shell wrapper script named wrapper in installpath
# (defaults to the bindir) to execute target (default of wrapper) by
# first optionally setting LD_LIBRARY_PATH to the colon-delimited
# libpaths followed by optionally changing directory to chdir.
make_wrapper() {
	local wrapper=$1 bin=$2 chdir=$3 libdir=$4 path=$5
	local tmpwrapper=$(emktemp)
	has "${EAPI:-0}" 0 1 2 && local EPREFIX=""

	(
	echo '#!/bin/sh'
	if [[ -n ${libdir} ]] ; then
		local var
		if [[ ${CHOST} == *-darwin* ]] ; then
			var=DYLD_LIBRARY_PATH
		else
			var=LD_LIBRARY_PATH
		fi
		cat <<-EOF
			if [ "\${${var}+set}" = "set" ] ; then
				export ${var}="\${${var}}:${EPREFIX}${libdir}"
			else
				export ${var}="${EPREFIX}${libdir}"
			fi
		EOF
	fi
	[[ -n ${chdir} ]] && printf 'cd "%s" &&\n' "${EPREFIX}${chdir}"
	# We don't want to quote ${bin} so that people can pass complex
	# things as ${bin} ... "./someprog --args"
	printf 'exec %s "$@"\n' "${bin/#\//${EPREFIX}/}"
	) > "${tmpwrapper}"
	chmod go+rx "${tmpwrapper}"

	if [[ -n ${path} ]] ; then
		(
		exeopts -m 0755
		exeinto "${path}"
		newexe "${tmpwrapper}" "${wrapper}"
		) || die
	else
		newbin "${tmpwrapper}" "${wrapper}" || die
	fi
}

path_exists() {
	eerror "path_exists has been removed.  Please see the following post"
	eerror "for a replacement snippet:"
	eerror "https://blogs.gentoo.org/mgorny/2018/08/09/inlining-path_exists/"
	die "path_exists is banned"
}

# @FUNCTION: use_if_iuse
# @USAGE: <flag>
# @DESCRIPTION:
# Return true if the given flag is in USE and IUSE.
#
# Note that this function should not be used in the global scope.
use_if_iuse() {
	in_iuse $1 || return 1
	use $1
}

case ${EAPI:-0} in
0|1|2|3|4)

# @FUNCTION: usex
# @USAGE: <USE flag> [true output] [false output] [true suffix] [false suffix]
# @DESCRIPTION:
# Proxy to declare usex for package managers or EAPIs that do not provide it
# and use the package manager implementation when available (i.e. EAPI >= 5).
# If USE flag is set, echo [true output][true suffix] (defaults to "yes"),
# otherwise echo [false output][false suffix] (defaults to "no").
usex() { use "$1" && echo "${2-yes}$4" || echo "${3-no}$5" ; } #382963

;;
esac

case ${EAPI:-0} in
0|1|2|3|4|5)

# @FUNCTION: einstalldocs
# @DESCRIPTION:
# Install documentation using DOCS and HTML_DOCS, in EAPIs that do not
# provide this function.  When available (i.e., in EAPI 6 or later),
# the package manager implementation should be used instead.
#
# If DOCS is declared and non-empty, all files listed in it are
# installed.  The files must exist, otherwise the function will fail.
# In EAPI 4 and 5, DOCS may specify directories as well; in earlier
# EAPIs using directories is unsupported.
#
# If DOCS is not declared, the files matching patterns given
# in the default EAPI implementation of src_install will be installed.
# If this is undesired, DOCS can be set to empty value to prevent any
# documentation from being installed.
#
# If HTML_DOCS is declared and non-empty, all files and/or directories
# listed in it are installed as HTML docs (using dohtml).
#
# Both DOCS and HTML_DOCS can either be an array or a whitespace-
# separated list. Whenever directories are allowed, '<directory>/.' may
# be specified in order to install all files within the directory
# without creating a sub-directory in docdir.
#
# Passing additional options to dodoc and dohtml is not supported.
# If you needed such a thing, you need to call those helpers explicitly.
einstalldocs() {
	debug-print-function ${FUNCNAME} "${@}"

	local dodoc_opts=-r
	has ${EAPI} 0 1 2 3 && dodoc_opts=

	if ! declare -p DOCS &>/dev/null ; then
		local d
		for d in README* ChangeLog AUTHORS NEWS TODO CHANGES \
				THANKS BUGS FAQ CREDITS CHANGELOG ; do
			if [[ -s ${d} ]] ; then
				dodoc "${d}" || die
			fi
		done
	elif [[ $(declare -p DOCS) == "declare -a"* ]] ; then
		if [[ ${DOCS[@]} ]] ; then
			dodoc ${dodoc_opts} "${DOCS[@]}" || die
		fi
	else
		if [[ ${DOCS} ]] ; then
			dodoc ${dodoc_opts} ${DOCS} || die
		fi
	fi

	if [[ $(declare -p HTML_DOCS 2>/dev/null) == "declare -a"* ]] ; then
		if [[ ${HTML_DOCS[@]} ]] ; then
			dohtml -r "${HTML_DOCS[@]}" || die
		fi
	else
		if [[ ${HTML_DOCS} ]] ; then
			dohtml -r ${HTML_DOCS} || die
		fi
	fi

	return 0
}

# @FUNCTION: in_iuse
# @USAGE: <flag>
# @DESCRIPTION:
# Determines whether the given flag is in IUSE.  Strips IUSE default
# prefixes as necessary.  In EAPIs where it is available (i.e., EAPI 6
# or later), the package manager implementation should be used instead.
#
# Note that this function must not be used in the global scope.
in_iuse() {
	debug-print-function ${FUNCNAME} "${@}"
	[[ ${#} -eq 1 ]] || die "Invalid args to ${FUNCNAME}()"

	local flag=${1}
	local liuse=( ${IUSE} )

	has "${flag}" "${liuse[@]#[+-]}"
}

;;
esac

case ${EAPI:-0} in
0|1|2|3|4|5|6)

# @FUNCTION: eqawarn
# @USAGE: [message]
# @DESCRIPTION:
# Proxy to ewarn for package managers that don't provide eqawarn and use the PM
# implementation if available. Reuses PORTAGE_ELOG_CLASSES as set by the dev
# profile.
if ! declare -F eqawarn >/dev/null ; then
	eqawarn() {
		has qa ${PORTAGE_ELOG_CLASSES} && ewarn "$@"
		:
	}
fi

;;
esac

fi
