# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: golang-build.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# @BLURB: Eclass that provides base functions for Go packages.
# @DESCRIPTION:
# This eclass provides base functions for software written in the Go
# programming language; it also provides the build-time dependency on
# dev-lang/go.

case "${EAPI:-0}" in
	5|6)
		;;
	*)
		die "${ECLASS}: Unsupported eapi (EAPI=${EAPI})"
		;;
esac

if [[ -z ${_GOLANG_BASE} ]]; then

_GOLANG_BASE=1

DEPEND=">=dev-lang/go-1.8"

# Do not complain about CFLAGS etc since go projects do not use them.
QA_FLAGS_IGNORED='.*'

STRIP_MASK="*.a"

# @ECLASS-VARIABLE: EGO_PN
# @REQUIRED
# @DESCRIPTION:
# This is the import path for the go package to build. Please emerge
# dev-lang/go and read "go help importpath" for syntax.
#
# Example:
# @CODE
# EGO_PN=github.com/user/package
# @CODE

# @FUNCTION: ego_pn_check
# @DESCRIPTION:
# Make sure EGO_PN has a value.
ego_pn_check() {
	[[ -z "${EGO_PN}" ]] &&
		die "${ECLASS}.eclass: EGO_PN is not set"
	return 0
}

# @FUNCTION: get_golibdir
# @DESCRIPTION:
# Return the non-prefixed library directory where Go packages
# should be installed
get_golibdir() {
	echo /usr/lib/go-gentoo
}

# @FUNCTION: get_golibdir_gopath
# @DESCRIPTION:
# Return the library directory where Go packages should be installed
# This is the prefixed version which should be included in GOPATH
get_golibdir_gopath() {
	echo "${EPREFIX}$(get_golibdir)"
}

# @FUNCTION: golang_install_pkgs
# @DESCRIPTION:
# Install Go packages.
# This function assumes that $cwd is a Go workspace.
golang_install_pkgs() {
	debug-print-function ${FUNCNAME} "$@"

	ego_pn_check
	insinto "$(get_golibdir)"
	insopts -m0644 -p # preserve timestamps for bug 551486
	doins -r pkg src
}

fi
