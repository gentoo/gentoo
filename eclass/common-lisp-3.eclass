# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: common-lisp-3.eclass
# @MAINTAINER:
# Common Lisp project <common-lisp@gentoo.org>
# @BLURB: functions to support the installation of Common Lisp libraries
# @DESCRIPTION:
# Since Common Lisp libraries share similar structure, this eclass aims
# to provide a simple way to write ebuilds with these characteristics.

inherit eutils

# @ECLASS-VARIABLE: CLIMPLEMENTATIONS
# @DESCRIPTION:
# Common Lisp implementations
CLIMPLEMENTATIONS="sbcl clisp clozurecl cmucl ecls gcl abcl"

# @ECLASS-VARIABLE: CLSOURCEROOT
# @DESCRIPTION:
# Default path of Common Lisp libraries sources. Sources will
# be installed into ${CLSOURCEROOT}/${CLPACKAGE}.
CLSOURCEROOT="${ROOT%/}"/usr/share/common-lisp/source

# @ECLASS-VARIABLE: CLSYSTEMROOT
# @DESCRIPTION:
# Default path to find any asdf file. Any asdf files will be
# symlinked in ${CLSYSTEMROOT}/${CLSYSTEM} as they may be in
# an arbitrarily deeply nested directory under ${CLSOURCEROOT}/${CLPACKAGE}.
CLSYSTEMROOT="${ROOT%/}"/usr/share/common-lisp/systems

# @ECLASS-VARIABLE: CLPACKAGE
# @DESCRIPTION:
# Default package name. To override, set these after inheriting this eclass.
CLPACKAGE="${PN}"

PDEPEND="virtual/commonlisp"

EXPORT_FUNCTIONS src_compile src_install

# @FUNCTION: common-lisp-3_src_compile
# @DESCRIPTION:
# Since there's nothing to build in most cases, default doesn't do
# anything.
common-lisp-3_src_compile() {
	true;
}

# @FUNCTION: absolute-path-p
# @DESCRIPTION:
# Returns true if ${1} is an absolute path.
absolute-path-p() {
	[[ $# -eq 1 ]] || die "${FUNCNAME[0]} must receive one argument"
	[[ ${1} == /* ]]
}

# @FUNCTION: common-lisp-install-one-source
# @DESCRIPTION:
# Installs ${2} source file in ${3} inside CLSOURCEROOT/CLPACKAGE.
common-lisp-install-one-source() {
	[[ $# -eq 3 ]] || die "${FUNCNAME[0]} must receive exactly three arguments"

	local fpredicate=${1}
	local source=${2}
	local target="${CLSOURCEROOT}/${CLPACKAGE}/${3}"

	if absolute-path-p "${source}" ; then
		die "Cannot install files with absolute path: ${source}"
	fi

	if ${fpredicate} "${source}" ; then
		insinto "${target}"
		doins "${source}" || die "Failed to install ${source} into $(dirname "${target}")"
	fi
}

# @FUNCTION: lisp-file-p
# @USAGE: <file>
# @DESCRIPTION:
# Returns true if ${1} is lisp source file.
lisp-file-p() {
	[[ $# -eq 1 ]] || die "${FUNCNAME[0]} must receive one argument"

	[[ ${1} =~ \.(lisp|lsp|cl)$ ]]
}

# @FUNCTION: common-lisp-get-fpredicate
# @USAGE: <type>
# @DESCRIPTION:
# Outputs the corresponding predicate to check files of type ${1}.
common-lisp-get-fpredicate() {
	[[ $# -eq 1 ]] || die "${FUNCNAME[0]} must receive one argument"

	local ftype=${1}
	case ${ftype} in
		"lisp") echo "lisp-file-p" ;;
		"all" ) echo "true" ;;
		* ) die "Unknown filetype specifier ${ftype}" ;;
	esac
}

# @FUNCTION: common-lisp-install-sources
# @USAGE: <path> [...]
# @DESCRIPTION:
# Recursively install lisp sources of type ${2} if ${1} is -t or
# Lisp by default. When given a directory, it will be recursively
# scanned for Lisp source files with suffixes: .lisp, .lsp or .cl.
common-lisp-install-sources() {
	local ftype="lisp"
	if [[ ${1} == "-t" ]] ; then
		ftype=${2}
		shift ; shift
	fi

	[[ $# -ge 1 ]] || die "${FUNCNAME[0]} must receive one non-option argument"

	local fpredicate=$(common-lisp-get-fpredicate "${ftype}")

	for path in "${@}" ; do
		if [[ -f ${path} ]] ; then
			common-lisp-install-one-source ${fpredicate} "${path}" "$(dirname "${path}")"
		elif [[ -d ${path} ]] ; then
			common-lisp-install-sources -t ${ftype} $(find "${path}" -type f)
		else
			die "${path} is neither a regular file nor a directory"
		fi
	done
}

# @FUNCTION: common-lisp-install-one-asdf
# @USAGE: <file>
# @DESCRIPTION:
# Installs ${1} asdf file in CLSOURCEROOT/CLPACKAGE and symlinks it in
# CLSYSTEMROOT.
common-lisp-install-one-asdf() {
	[[ $# != 1 ]] && die "${FUNCNAME[0]} must receive exactly one argument"

	# the suffix «.asd» is optional
	local source=${1%.asd}.asd
	common-lisp-install-one-source true "${source}" "$(dirname "${source}")"
	local target="${CLSOURCEROOT%/}/${CLPACKAGE}/${source}"
	dosym "${target}" "${CLSYSTEMROOT%/}/$(basename ${target})"
}

# @FUNCTION: common-lisp-install-asdf
# @USAGE: <path> [...]
# @DESCRIPTION:
# Installs all ASDF files and creates symlinks in CLSYSTEMROOT.
# When given a directory, it will be recursively scanned for ASDF
# files with extension .asd.
common-lisp-install-asdf() {
	dodir "${CLSYSTEMROOT}"

	[[ $# = 0 ]] && set - ${CLSYSTEMS}
	[[ $# = 0 ]] && set - $(find . -type f -name \*.asd)
	for sys in "${@}" ; do
		common-lisp-install-one-asdf ${sys}
	done
}

# @FUNCTION: common-lisp-3_src_install
# @DESCRIPTION:
# Recursively install Lisp sources, asdf files and most common doc files.
common-lisp-3_src_install() {
	common-lisp-install-sources .
	common-lisp-install-asdf
	for i in AUTHORS README* HEADER TODO* CHANGELOG Change[lL]og CHANGES BUGS CONTRIBUTORS *NEWS* ; do
		[[ -f ${i} ]] && dodoc ${i}
	done
}

# @FUNCTION: common-lisp-find-lisp-impl
# @DESCRIPTION:
# Outputs an installed Common Lisp implementation. Transverses
# CLIMPLEMENTATIONS to find it.
common-lisp-find-lisp-impl() {
	for lisp in ${CLIMPLEMENTATIONS} ; do
		[[ "$(best_version dev-lisp/${lisp})" ]] && echo "${lisp}" && return
	done
	die "No CommonLisp implementation found"
}

# @FUNCTION: common-lisp-export-impl-args
# @USAGE: <lisp-implementation>
# @DESCRIPTION:
# Export a few variables containing the switches necessary
# to make the CL implementation perform basic functions:
#   * CL_BINARY: Common Lisp implementation
#   * CL_NORC: don't load syste-wide or user-specific initfiles
#   * CL_LOAD: load a certain file
#   * CL_EVAL: eval a certain expression at startup
common-lisp-export-impl-args() {
	if [[ $# != 1 ]]; then
		eerror "Usage: ${FUNCNAME[0]} lisp-implementation"
		die "${FUNCNAME[0]}: wrong number of arguments: $#"
	fi
	CL_BINARY="${1}"
	case "${CL_BINARY}" in
		sbcl)
			CL_NORC="--sysinit /dev/null --userinit /dev/null"
			CL_LOAD="--load"
			CL_EVAL="--eval"
			;;
		clisp)
			CL_NORC="-norc"
			CL_LOAD="-i"
			CL_EVAL="-x"
			;;
		clozure | clozurecl | ccl | openmcl)
			CL_BINARY="ccl"
			CL_NORC="--no-init"
			CL_LOAD="--load"
			CL_EVAL="--eval"
			;;
		cmucl)
			CL_NORC="-nositeinit -noinit"
			CL_LOAD="-load"
			CL_EVAL="-eval"
			;;
		ecl | ecls)
			CL_BINARY="ecl"
			CL_NORC="-norc"
			CL_LOAD="-load"
			CL_EVAL="-eval"
			;;
		abcl)
			CL_NORC="--noinit"
			CL_LOAD="--load"
			CL_EVAL="--eval"
			;;
		*)
			die "${CL_BINARY} is not supported by ${0}"
			;;
	esac
	export CL_BINARY CL_NORC CL_LOAD CL_EVAL
}
