# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="A cellular automata setting the background of your X Windows desktop under water"
HOMEPAGE="http://xdesktopwaves.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
RDEPEND="x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xextproto"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_compile() {
	tc-export CC
	emake
	emake -C xdwapi
}

src_install() {
	dobin xdesktopwaves xdwapi/xdwapidemo
	doman xdesktopwaves.1
	insinto /usr/share/pixmaps
	doins xdesktopwaves.xpm
	make_desktop_entry xdesktopwaves
	einstalldocs
}

pkg_preinst() {
	elog "To see what xdesktopwaves is able to do, start it by running"
	elog "'xdesktopwaves' and then run 'xdwapidemo'. You should see the"
	elog "supported effects on your desktop"
}
