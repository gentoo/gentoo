# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: autotools-multilib.eclass
# @MAINTAINER:
# gx86-multilib team <multilib@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# @BLURB: autotools-utils wrapper for multilib builds
# @DESCRIPTION:
# The autotools-multilib.eclass provides a glue between
# autotools-utils.eclass(5) and multilib-minimal.eclass(5), aiming
# to provide a convenient way to build packages using autotools
# for multiple ABIs.
#
# Inheriting this eclass sets IUSE and exports default multilib_src_*()
# sub-phases that call autotools-utils phase functions for each ABI
# enabled. The multilib_src_*() functions can be defined in ebuild just
# like in multilib-minimal.

# EAPI=4 is required for meaningful MULTILIB_USEDEP.
case ${EAPI:-0} in
	6) die "${ECLASS}.eclass is banned in EAPI ${EAPI}";;
	4|5) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

inherit autotools-utils eutils multilib-build multilib-minimal

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install

# Note: _at_args[@] passing is a backwards compatibility measure.
# Don't use it in new packages.

autotools-multilib_src_prepare() {
	autotools-utils_src_prepare "${@}"

	[[ ${AUTOTOOLS_IN_SOURCE_BUILD} ]] && multilib_copy_sources
}

multilib_src_configure() {
	[[ ${AUTOTOOLS_IN_SOURCE_BUILD} ]] && local ECONF_SOURCE=${BUILD_DIR}
	autotools-utils_src_configure "${_at_args[@]}"
}

autotools-multilib_src_configure() {
	local _at_args=( "${@}" )

	multilib-minimal_src_configure
}

multilib_src_compile() {
	emake "${_at_args[@]}"
}

autotools-multilib_src_compile() {
	local _at_args=( "${@}" )

	multilib-minimal_src_compile
}

multilib_src_test() {
	autotools-utils_src_test "${_at_args[@]}"
}

autotools-multilib_src_test() {
	local _at_args=( "${@}" )

	multilib-minimal_src_test
}

multilib_src_install() {
	emake DESTDIR="${D}" "${_at_args[@]}" install
}

multilib_src_install_all() {
	einstalldocs

	# Remove libtool files and unnecessary static libs
	local prune_ltfiles=${AUTOTOOLS_PRUNE_LIBTOOL_FILES}
	if [[ ${prune_ltfiles} != none ]]; then
		prune_libtool_files ${prune_ltfiles:+--${prune_ltfiles}}
	fi
}

autotools-multilib_src_install() {
	local _at_args=( "${@}" )

	multilib-minimal_src_install
}
