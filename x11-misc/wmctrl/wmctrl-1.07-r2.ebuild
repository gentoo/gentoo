# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="command line tool to interact with an EWMH/NetWM compatible X Window Manager"
HOMEPAGE="http://sweb.cz/tripie/utils/wmctrl"
SRC_URI="http://sweb.cz/tripie/utils/${PN}/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ppc ~ppc64 ~sparc x86 ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2:2
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXmu
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"

PATCHES=( "${FILESDIR}/amd64-Xlib.patch" )
