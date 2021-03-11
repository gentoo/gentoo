# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="Display information utility for X"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris ~x86-winnt"
IUSE="dga dmx xinerama"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXxf86vm
	x11-libs/libxcb
	dga? ( x11-libs/libXxf86dga )
	dmx? ( x11-libs/libdmx )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		"--without-xf86misc"
		$(use_with dga)
		$(use_with dmx)
		$(use_with xinerama)
	)

}
