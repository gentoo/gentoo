# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Command line tool to interact with an EWMH/NetWM compatible X Window Manager"
HOMEPAGE="http://sweb.cz/tripie/utils/wmctrl"
SRC_URI="http://sweb.cz/tripie/utils/wmctrl/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ppc ~ppc64 ~sparc x86 ~x86-linux"

RDEPEND="
	dev-libs/glib:2
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/amd64-Xlib.patch" )
