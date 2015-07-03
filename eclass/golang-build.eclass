# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/golang-build.eclass,v 1.3 2015/07/03 21:45:06 williamh Exp $

# @ECLASS: golang-build.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# @BLURB: Eclass for compiling go packages.
# @DESCRIPTION:
# This eclass provides default  src_compile, src_test and src_install
# functions for software written in the Go programming language.

case "${EAPI:-0}" in
	5)
		;;
	*)
		die "${ECLASS}: Unsupported eapi (EAPI=${EAPI})"
		;;
esac

EXPORT_FUNCTIONS src_compile src_install src_test

if [[ -z ${_GOLANG_BUILD} ]]; then

_GOLANG_BUILD=1

DEPEND=">=dev-lang/go-1.4.2"
STRIP_MASK="*.a"

# @ECLASS-VARIABLE: EGO_PN
# @REQUIRED
# @DESCRIPTION:
# This is the import path for the go package(s) to build. Please emerge
# dev-lang/go and read "go help importpath" for syntax.
#
# Example:
# @CODE
# EGO_PN=github.com/user/package
# @CODE

# @FUNCTION: _golang-build_setup
# @INTERNAL
# @DESCRIPTION:
# Make sure EGO_PN has a value.
_golang-build_setup() {
	[[ -z "${EGO_PN}" ]] &&
		die "${ECLASS}.eclass: EGO_PN is not set"
	return 0
}

golang-build_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	_golang-build_setup
	set -- env GOPATH="${WORKDIR}/${P}:${EPREFIX}/usr/lib/go-gentoo" \
		go build -v -work -x "${EGO_PN}"
	echo "$@"
	"$@" || die
}

golang-build_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	_golang-build_setup
	set -- env GOPATH="${WORKDIR}/${P}:${EPREFIX}/usr/lib/go-gentoo" \
		go install -v -work -x "${EGO_PN}"
	echo "$@"
	"$@" || die
	insinto /usr/lib/go-gentoo
	insopts -m0644 -p # preserve timestamps for bug 551486
	doins -r pkg src
}

golang-build_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	_golang-build_setup
	set -- env GOPATH="${WORKDIR}/${P}:${EPREFIX}/usr/lib/go-gentoo" \
		go test -v -work -x "${EGO_PN}"
	echo "$@"
	"$@" || die
}

fi
