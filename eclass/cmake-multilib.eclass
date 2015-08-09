# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: cmake-multilib.eclass
# @MAINTAINER:
# gx86-multilib team <multilib@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# @BLURB: cmake-utils wrapper for multilib builds
# @DESCRIPTION:
# The cmake-multilib.eclass provides a glue between cmake-utils.eclass(5)
# and multilib-minimal.eclass(5), aiming to provide a convenient way
# to build packages using cmake for multiple ABIs.
#
# Inheriting this eclass sets IUSE and exports default multilib_src_*()
# sub-phases that call cmake-utils phase functions for each ABI enabled.
# The multilib_src_*() functions can be defined in ebuild just like
# in multilib-minimal, yet they ought to call appropriate cmake-utils
# phase rather than 'default'.

# EAPI=5 is required for meaningful MULTILIB_USEDEP.
case ${EAPI:-0} in
	5) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

if [[ ${CMAKE_IN_SOURCE_BUILD} ]]; then
	die "${ECLASS}: multilib support requires out-of-source builds."
fi

inherit cmake-utils multilib-minimal

EXPORT_FUNCTIONS src_configure src_compile src_test src_install

cmake-multilib_src_configure() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_configure
}

multilib_src_configure() {
	cmake-utils_src_configure "${_cmake_args[@]}"
}

cmake-multilib_src_compile() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_compile
}

multilib_src_compile() {
	cmake-utils_src_compile "${_cmake_args[@]}"
}

cmake-multilib_src_test() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_test
}

multilib_src_test() {
	cmake-utils_src_test "${_cmake_args[@]}"
}

cmake-multilib_src_install() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_install
}

multilib_src_install() {
	cmake-utils_src_install "${_cmake_args[@]}"
}
