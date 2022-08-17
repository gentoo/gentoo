# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command line tool to interact with an EWMH/NetWM compatible X Window Manager"
HOMEPAGE="http://tripie.sweb.cz/utils/wmctrl/"
SRC_URI="http://tripie.sweb.cz/utils/wmctrl/dist/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 ppc ~ppc64 ~riscv ~sparc x86 ~x86-linux"

RDEPEND="
	dev-libs/glib:2
	x11-libs/libX11
	x11-libs/libXmu"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-64bit-xlib.patch
)
