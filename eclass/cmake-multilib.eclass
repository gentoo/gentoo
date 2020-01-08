# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cmake-multilib.eclass
# @MAINTAINER:
# gx86-multilib team <multilib@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
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

# @ECLASS-VARIABLE: CMAKE_ECLASS
# @DESCRIPTION:
# Default is "cmake-utils" for compatibility. Specify "cmake" for ebuilds
# that ported from cmake-utils.eclass to cmake.eclass already.
: ${CMAKE_ECLASS:=cmake-utils}

case ${EAPI:-0} in
	[67]) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

if [[ ${CMAKE_IN_SOURCE_BUILD} ]]; then
	die "${ECLASS}: multilib support requires out-of-source builds."
fi

case ${CMAKE_ECLASS} in
	cmake-utils|cmake) ;;
	*)
		eerror "Unknown value for \${CMAKE_ECLASS}"
		die "Value ${CMAKE_ECLASS} is not supported"
		;;
esac

inherit ${CMAKE_ECLASS} multilib-minimal

EXPORT_FUNCTIONS src_configure src_compile src_test src_install

cmake-multilib_src_configure() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_configure
}

multilib_src_configure() {
	${CMAKE_ECLASS}_src_configure "${_cmake_args[@]}"
}

cmake-multilib_src_compile() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_compile
}

multilib_src_compile() {
	${CMAKE_ECLASS}_src_compile "${_cmake_args[@]}"
}

cmake-multilib_src_test() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_test
}

multilib_src_test() {
	${CMAKE_ECLASS}_src_test "${_cmake_args[@]}"
}

cmake-multilib_src_install() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_install
}

multilib_src_install() {
	${CMAKE_ECLASS}_src_install "${_cmake_args[@]}"
}
