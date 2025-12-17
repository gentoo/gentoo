# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: out-of-source.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7 8 9
# @BLURB: convenient wrapper to build autotools packages out-of-source
# @DESCRIPTION:
# This eclass provides a minimalistic wrapper interface to easily
# build autotools (and alike) packages out-of-source. It is meant
# to resemble the interface used by multilib-minimal without actually
# requiring the package to be multilib.
#
# For the simplest ebuilds, it is enough to inherit the eclass
# and the new phase functions will automatically build the package
# out-of-source. If you need to redefine one of the default phases
# src_configure() through src_install(), you need to define
# the matching sub-phases: my_src_configure(), my_src_compile(),
# my_src_test() and/or my_src_install(). Those sub-phase functions
# will be run inside the build directory. Additionally,
# my_src_install_all() is provided to perform doc-install and other
# common tasks that are done in source directory.
#
# Example use:
# @CODE
# inherit out-of-source
#
# my_src_configure() {
#     econf \
#         --disable-static
# }
# @CODE

if [[ -z ${_OUT_OF_SOURCE_ECLASS} ]]; then
_OUT_OF_SOURCE_ECLASS=1

case ${EAPI} in
	7|8|9);;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @ECLASS_VARIABLE: BUILD_DIR
# @OUTPUT_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The current build directory.  Defaults to ${WORKDIR}/${P}_build
# if unset.

# @FUNCTION: out-of-source_src_configure
# @DESCRIPTION:
# The default src_configure() implementation establishes a BUILD_DIR,
# sets ECONF_SOURCE to the current directory (usually S), and runs
# my_src_configure() (or the default) inside it.
out-of-source_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	# set some BUILD_DIR if we don't have one yet
	: "${BUILD_DIR:=${WORKDIR}/${P}_build}"
	local ECONF_SOURCE=${PWD}

	mkdir -p "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" >/dev/null || die
	if declare -f my_src_configure >/dev/null ; then
		my_src_configure
	else
		default_src_configure
	fi
	popd >/dev/null || die
}

# @FUNCTION: out-of-source_src_compile
# @DESCRIPTION:
# The default src_compile() implementation runs my_src_compile()
# (or the default) inside the build directory.
out-of-source_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	pushd "${BUILD_DIR}" >/dev/null || die
	if declare -f my_src_compile >/dev/null ; then
		my_src_compile
	else
		default_src_compile
	fi
	popd >/dev/null || die
}

# @FUNCTION: out-of-source_src_test
# @DESCRIPTION:
# The default src_test() implementation runs my_src_test()
# (or the default) inside the build directory.
out-of-source_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	pushd "${BUILD_DIR}" >/dev/null || die
	if declare -f my_src_test >/dev/null ; then
		my_src_test
	else
		default_src_test
	fi
	popd >/dev/null || die
}

# @FUNCTION: out-of-source_src_install
# @DESCRIPTION:
# The default src_install() implementation runs my_src_install()
# (or the 'make install' part of the default) inside the build directory,
# followed by a call to my_src_install_all() (or 'einstalldocs' part
# of the default) in the original working directory.
out-of-source_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	pushd "${BUILD_DIR}" >/dev/null || die
	if declare -f my_src_install >/dev/null ; then
		my_src_install
	else
		if [[ -f Makefile || -f GNUmakefile || -f makefile ]] ; then
			emake DESTDIR="${D}" install
		fi
	fi
	popd >/dev/null || die

	if declare -f my_src_install_all >/dev/null ; then
		my_src_install_all
	else
		einstalldocs
	fi
}

fi

EXPORT_FUNCTIONS src_configure src_compile src_test src_install
