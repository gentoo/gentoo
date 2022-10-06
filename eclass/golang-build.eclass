# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: golang-build.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @PROVIDES: golang-base
# @BLURB: Eclass for compiling go packages.
# @DEPRECATED: go-module.eclass
# @DESCRIPTION:
# This eclass provides default ``src_compile``, ``src_test`` and ``src_install``
# functions for software written in the Go programming language.

inherit golang-base

case "${EAPI:-0}" in
	5|6|7)
		;;
	*)
		die "${ECLASS}: Unsupported eapi (EAPI=${EAPI})"
		;;
esac

EXPORT_FUNCTIONS src_compile src_install src_test

if [[ -z ${_GOLANG_BUILD} ]]; then

_GOLANG_BUILD=1

# @ECLASS_VARIABLE: EGO_BUILD_FLAGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# This allows you to pass build flags to the Go compiler. These flags
# are common to the ``go build`` and ``go install`` commands used below.
# Please emerge ``dev-lang/go`` and run ``go help build`` for the
# documentation for these flags.
#
# Example:
# @CODE
# EGO_BUILD_FLAGS="-ldflags \"-X main.version ${PV}\""
# @CODE

# @ECLASS_VARIABLE: EGO_PN
# @REQUIRED
# @DESCRIPTION:
# This is the import path for the go package(s) to build. Please emerge
# ``dev-lang/go`` and read ``go help importpath`` for syntax.
#
# Example:
# @CODE
# EGO_PN=github.com/user/package
# @CODE

golang-build_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	ego_pn_check
	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		GOCACHE="${T}/go-cache" \
		go build -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
	echo "$@"
	"$@" || die
}

golang-build_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	ego_pn_check
	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
	echo "$@"
	"$@" || die
	golang_install_pkgs
}

golang-build_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	ego_pn_check
	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go test -v -work -x "${EGO_PN}"
	echo "$@"
	"$@" || die
}

fi
