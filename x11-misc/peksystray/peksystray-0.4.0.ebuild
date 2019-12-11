# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="A system tray dockapp for window managers supporting docking"
HOMEPAGE="http://peksystray.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libXt"

PATCHES=( "${FILESDIR}/${P}-asneeded.patch" )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	dobin src/peksystray
	default
}
