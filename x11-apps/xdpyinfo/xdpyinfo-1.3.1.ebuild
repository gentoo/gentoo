# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xdpyinfo/xdpyinfo-1.3.1.ebuild,v 1.11 2015/03/03 10:42:39 dlan Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="Display information utility for X"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris ~x86-winnt"
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
	x11-proto/compositeproto
	x11-proto/inputproto
	x11-proto/kbproto
	x11-proto/renderproto
	x11-proto/xf86vidmodeproto
	x11-proto/xextproto
	x11-proto/xproto
	dga? ( x11-proto/xf86dgaproto )
	dmx? ( x11-proto/dmxproto )
	xinerama? ( x11-proto/xineramaproto )
"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		"--without-xf86misc"
		$(use_with dga)
		$(use_with dmx)
		$(use_with xinerama)
	)

}
