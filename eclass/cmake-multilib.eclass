# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cmake-multilib.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: cmake multilib-minimal
# @BLURB: cmake wrapper for multilib builds
# @DESCRIPTION:
# The cmake-multilib.eclass provides a glue between cmake.eclass(5)
# and multilib-minimal.eclass(5), aiming to provide a convenient way
# to build packages using cmake for multiple ABIs.
#
# Inheriting this eclass sets IUSE and exports default multilib_src_*()
# sub-phases that call cmake phase functions for each ABI enabled.
# The multilib_src_*() functions can be defined in ebuild just like
# in multilib-minimal, yet they ought to call appropriate cmake
# phase rather than 'default'.

# @ECLASS_VARIABLE: CMAKE_ECLASS
# @DEPRECATED: none
# @DESCRIPTION:
# Only "cmake" is supported.
: ${CMAKE_ECLASS:=cmake}

case ${EAPI} in
	7|8)
		case ${CMAKE_ECLASS} in
			cmake) ;;
			*)
				eerror "Unknown value for \${CMAKE_ECLASS}"
				die "Value ${CMAKE_ECLASS} is not supported"
				;;
		esac
		;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ${CMAKE_IN_SOURCE_BUILD} ]]; then
	die "${ECLASS}: multilib support requires out-of-source builds."
fi

if [[ -z ${_CMAKE_MULTILIB_ECLASS} ]]; then
_CMAKE_MULTILIB_ECLASS=1

inherit cmake multilib-minimal

cmake-multilib_src_configure() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_configure
}

multilib_src_configure() {
	cmake_src_configure "${_cmake_args[@]}"
}

cmake-multilib_src_compile() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_compile
}

multilib_src_compile() {
	cmake_src_compile "${_cmake_args[@]}"
}

cmake-multilib_src_test() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_test
}

multilib_src_test() {
	cmake_src_test "${_cmake_args[@]}"
}

cmake-multilib_src_install() {
	local _cmake_args=( "${@}" )

	multilib-minimal_src_install
}

multilib_src_install() {
	cmake_src_install "${_cmake_args[@]}"
}

fi

EXPORT_FUNCTIONS src_configure src_compile src_test src_install
