# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="display ditroff output"
KEYWORDS="amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~s390 sparc x86"
IUSE="xft"

RDEPEND="
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libX11
	xft? (
		x11-libs/libXft
		x11-libs/libXrender
		media-libs/fontconfig
	)"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_with xft)
	)
	xorg-3_src_configure
}
