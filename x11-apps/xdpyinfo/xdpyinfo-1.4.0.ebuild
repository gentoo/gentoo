# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-meson

DESCRIPTION="Display information utility for X"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="dga xinerama"

RDEPEND="
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXpresent
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXxf86vm
	dga? ( x11-libs/libXxf86dga )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		-Dxf86misc=disabled
		$(meson_feature dga)
		$(meson_feature xinerama)
	)
	xorg-meson_src_configure
}
