# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdesktopwaves/xdesktopwaves-1.3-r1.ebuild,v 1.5 2012/01/04 21:00:00 ranger Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="A cellular automata setting the background of your X Windows desktop under water"
HOMEPAGE="http://xdesktopwaves.sourceforge.net/"
LICENSE="GPL-2"
RDEPEND="x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	tc-export CC
	emake || die "failed building program"
	cd xdwapi
	emake || die "failed building demo"
}

src_install() {
	dobin xdesktopwaves xdwapi/xdwapidemo
	doman xdesktopwaves.1
	insinto /usr/share/pixmaps
	doins xdesktopwaves.xpm
	make_desktop_entry xdesktopwaves
	dodoc README
}

pkg_preinst() {
	elog "To see what xdesktopwaves is able to do, start it by running"
	elog "'xdesktopwaves' and then run 'xdwapidemo'. You should see the"
	elog "supported effects on your desktop"
}
