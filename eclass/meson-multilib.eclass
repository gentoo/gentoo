# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: meson-multilib.eclass
# @MAINTAINER:
# Matt Turner <mattst88@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# Matt Turner <mattst88@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: meson multilib-minimal
# @BLURB: meson wrapper for multilib builds
# @DESCRIPTION:
# The meson-multilib.eclass provides a glue between meson.eclass(5)
# and multilib-minimal.eclass(5), aiming to provide a convenient way
# to build packages using meson for multiple ABIs.
#
# Inheriting this eclass sets IUSE and exports default multilib_src_*()
# sub-phases that call meson phase functions for each ABI enabled.
# The multilib_src_*() functions can be defined in ebuild just like
# in multilib-minimal, yet they ought to call appropriate meson
# phase rather than 'default'.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_MESON_MULTILIB_ECLASS} ]] ; then
_MESON_MULTILIB_ECLASS=1

inherit meson multilib-minimal

# @FUNCTION: meson_native_use_bool
# @USAGE: <USE flag> [option name]
# @DESCRIPTION:
# Given a USE flag and a meson project option, output a string like:
#
#   -Doption=true
#   -Doption=false
#
# if building for the native ABI (multilib_is_native_abi is true). Otherwise,
# output -Doption=false. If the project option is unspecified, it defaults
# to the USE flag.
meson_native_use_bool() {
	multilib_native_usex "${1}" "-D${2-${1}}=true" "-D${2-${1}}=false"
}

# @FUNCTION: meson_native_use_feature
# @USAGE: <USE flag> [option name]
# @DESCRIPTION:
# Given a USE flag and a meson project option, output a string like:
#
#   -Doption=enabled
#   -Doption=disabled
#
# if building for the native ABI (multilib_is_native_abi is true). Otherwise,
# output -Doption=disabled. If the project option is unspecified, it defaults
# to the USE flag.
meson_native_use_feature() {
	multilib_native_usex "${1}" "-D${2-${1}}=enabled" "-D${2-${1}}=disabled"
}

# @FUNCTION: meson_native_enabled
# @USAGE: <option name>
# @DESCRIPTION:
# Output -Doption=enabled option if executables are being built
# (multilib_is_native_abi is true). Otherwise, output -Doption=disabled option.
meson_native_enabled() {
	if multilib_is_native_abi; then
		echo "-D${1}=enabled"
	else
		echo "-D${1}=disabled"
	fi
}

# @FUNCTION: meson_native_true
# @USAGE: <option name>
# @DESCRIPTION:
# Output -Doption=true option if executables are being built
# (multilib_is_native_abi is true). Otherwise, output -Doption=false option.
meson_native_true() {
	if multilib_is_native_abi; then
		echo "-D${1}=true"
	else
		echo "-D${1}=false"
	fi
}

meson-multilib_src_configure() {
	local _meson_args=( "${@}" )

	multilib-minimal_src_configure
}

multilib_src_configure() {
	meson_src_configure "${_meson_args[@]}"
}

meson-multilib_src_compile() {
	local _meson_args=( "${@}" )

	multilib-minimal_src_compile
}

multilib_src_compile() {
	meson_src_compile "${_meson_args[@]}"
}

meson-multilib_src_test() {
	local _meson_args=( "${@}" )

	multilib-minimal_src_test
}

multilib_src_test() {
	meson_src_test "${_meson_args[@]}"
}

meson-multilib_src_install() {
	local _meson_args=( "${@}" )

	multilib-minimal_src_install
}

multilib_src_install() {
	meson_install "${_meson_args[@]}"
}

fi

EXPORT_FUNCTIONS src_configure src_compile src_test src_install
