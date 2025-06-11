# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: xorg-meson.eclass
# @MAINTAINER:
# x11@gentoo.org
# @AUTHOR:
# Author: Matt Turner <mattst88@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: meson meson-multilib
# @BLURB: Reduces code duplication in the X11 ebuilds.
# @DESCRIPTION:
# This eclass makes trivial X ebuilds possible for apps, drivers,
# and more. Many things that would normally be done in various functions
# can be accessed by setting variables instead, such as patching,
# passing options to meson and installing docs.
#
# All you need to do in a basic ebuild is inherit this eclass and set
# DESCRIPTION, KEYWORDS and RDEPEND/DEPEND. If your package is hosted
# with the other X packages, you don't need to set SRC_URI. Pretty much
# everything else should be automatic.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_XORG_MESON_ECLASS} ]]; then
_XORG_MESON_ECLASS=1

inherit flag-o-matic

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
fi

# @ECLASS_VARIABLE: XORG_MULTILIB
# @PRE_INHERIT
# @DESCRIPTION:
# If set to 'yes', multilib support for package will be enabled. Set
# before inheriting this eclass.
: "${XORG_MULTILIB:="no"}"

[[ ${XORG_MULTILIB} == yes ]] && inherit meson-multilib || inherit meson

# @ECLASS_VARIABLE: XORG_BASE_INDIVIDUAL_URI
# @PRE_INHERIT
# @DESCRIPTION:
# Set up SRC_URI for individual releases. If set to an empty
# string, no SRC_URI will be provided by the eclass.
: "${XORG_BASE_INDIVIDUAL_URI="https://www.x.org/releases/individual"}"

# @ECLASS_VARIABLE: XORG_MODULE
# @PRE_INHERIT
# @DESCRIPTION:
# The subdirectory to download source from. Possible settings are app,
# doc, data, util, driver, font, lib, proto, xserver. Set above the
# inherit to override the default autoconfigured module.
: "${XORG_MODULE:="auto"}"
if [[ ${XORG_MODULE} == auto ]]; then
	case "${CATEGORY}/${P}" in
		app-doc/*)               XORG_MODULE=doc/     ;;
		media-fonts/*)           XORG_MODULE=font/    ;;
		x11-apps/*|x11-wm/*)     XORG_MODULE=app/     ;;
		x11-misc/*|x11-themes/*) XORG_MODULE=util/    ;;
		x11-base/*)              XORG_MODULE=xserver/ ;;
		x11-drivers/*)           XORG_MODULE=driver/  ;;
		x11-libs/*)              XORG_MODULE=lib/     ;;
		*)                       XORG_MODULE=         ;;
	esac
fi

# @ECLASS_VARIABLE: XORG_PACKAGE_NAME
# @PRE_INHERIT
# @DESCRIPTION:
# For git checkout the git repository might differ from package name.
# This variable can be used for proper directory specification
: "${XORG_PACKAGE_NAME:=${PN}}"

HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/${XORG_MODULE}${XORG_PACKAGE_NAME}"

# @ECLASS_VARIABLE: XORG_TARBALL_SUFFIX
# @PRE_INHERIT
# @DESCRIPTION:
# Most X11 projects provide tarballs as tar.xz. This eclass defaults to xz.
: "${XORG_TARBALL_SUFFIX:="xz"}"

if [[ ${PV} == *9999* ]]; then
	: "${EGIT_REPO_URI:="https://gitlab.freedesktop.org/xorg/${XORG_MODULE}${XORG_PACKAGE_NAME}.git"}"
elif [[ -n ${XORG_BASE_INDIVIDUAL_URI} ]]; then
	SRC_URI="${XORG_BASE_INDIVIDUAL_URI}/${XORG_MODULE}${P}.tar.${XORG_TARBALL_SUFFIX}"
fi

: "${SLOT:=0}"

# Set the license for the package. This can be overridden by setting
# LICENSE after the inherit. Nearly all freedesktop-hosted X packages
# are under the MIT license.
: "${LICENSE:=MIT}"

if [[ ${PN} == xf86-video-* || ${PN} == xf86-input-* ]]; then
	DEPEND+="  x11-base/xorg-proto"
	DEPEND+="  >=x11-base/xorg-server-1.20:=[xorg]"
	RDEPEND+=" >=x11-base/xorg-server-1.20:=[xorg]"
	if [[ ${PN} == xf86-video-* ]]; then
		DEPEND+="  >=x11-libs/libpciaccess-0.14"
		RDEPEND+=" >=x11-libs/libpciaccess-0.14"
	fi
fi
BDEPEND+=" virtual/pkgconfig"

# @ECLASS_VARIABLE: XORG_DOC
# @PRE_INHERIT
# @DESCRIPTION:
# Controls the installation of man3 developer documentation. Possible values
# are the name of the useflag or "no". Default value is "no".
: "${XORG_DOC:="no"}"

case ${XORG_DOC} in
	no)
		;;
	*)
		IUSE+=" ${XORG_DOC}"
		;;
esac

debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: DEPEND=${DEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: RDEPEND=${RDEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: PDEPEND=${PDEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: BDEPEND=${BDEPEND}"

# @FUNCTION: xorg-meson_src_unpack
# @DESCRIPTION:
# Simply unpack source code.
xorg-meson_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
	else
		unpack ${A}
	fi
}

# @FUNCTION: xorg-meson_flags_setup
# @INTERNAL
# @DESCRIPTION:
# Set up CFLAGS for a debug build
xorg-meson_flags_setup() {
	debug-print-function ${FUNCNAME} "$@"

	# Hardened flags break module autoloading et al (also fixes #778494)
	if [[ ${PN} == xorg-server || ${PN} == xf86-video-* || ${PN} == xf86-input-* ]]; then
		filter-flags -fno-plt
		append-ldflags -Wl,-z,lazy
	fi
}

# @VARIABLE: XORG_CONFIGURE_OPTIONS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of an additional options to pass to meson setup.

# @FUNCTION: xorg-meson_src_configure
# @DESCRIPTION:
# Perform any necessary pre-configuration steps, then run configure
xorg-meson_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	xorg-meson_flags_setup

	local emesonargs=(
		-Ddefault_library=shared
		"${XORG_CONFIGURE_OPTIONS[@]}"
	)

	if [[ ${XORG_MULTILIB} == yes ]]; then
		meson-multilib_src_configure "$@"
	else
		meson_src_configure "$@"
	fi
}

# @FUNCTION: xorg-meson_src_install
# @DESCRIPTION:
# Install a built package to ${ED}, performing any necessary steps.
xorg-meson_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${XORG_MULTILIB} == yes ]]; then
		meson-multilib_src_install "$@"
	else
		meson_src_install "$@"
	fi

	# Many X11 libraries unconditionally install developer documentation
	if ! in_iuse doc && [[ -d "${ED}"/usr/share/man/man3 ]]; then
		eqawarn "ebuild should set XORG_DOC=doc since package installs man3 documentation"
	fi

	if in_iuse doc && ! use doc; then
		rm -rf "${ED}"/usr/share/man/man3 || die
		find "${ED}"/usr -type d -empty -delete || die
	fi
}

fi

EXPORT_FUNCTIONS src_unpack src_configure src_install
