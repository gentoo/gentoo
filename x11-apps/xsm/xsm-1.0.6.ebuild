# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="X Session Manager"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="x11-libs/libXaw
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libICE
	x11-libs/libSM"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

pkg_setup() {
	# (#158056) /usr/$(get_libdir)/X11/xsm could be a symlink
	local XSMPATH="${EROOT}/usr/$(get_libdir)/X11/xsm"
	if [[ -L ${XSMPATH} ]]; then
		einfo "Removing symlink ${XSMPATH}"
		rm -f ${XSMPATH} || die "failed to remove symlink ${XSMPATH}"
	fi
	xorg-3_pkg_setup
}
