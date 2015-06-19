# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmenu/wmmenu-1.2-r1.ebuild,v 1.10 2014/08/10 20:08:05 slyfox Exp $

inherit eutils

IUSE=""
S=${WORKDIR}/${PN}
DESCRIPTION="WindowMaker DockApp: Provides a popup menu of icons like in AfterStep, as a dockable application"
SRC_URI="http://www.fcoutant.freesurf.fr/download/${P}.tar.gz"
HOMEPAGE="http://www.fcoutant.freesurf.fr/wmmenu.html"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
DEPEND="x11-libs/libdockapp"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-support-libdockapp-0.5.0.patch
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	emake EXTRACFLAGS="${CFLAGS}" || die "Compilation failed"
}

src_install() {
	dobin wmmenu
	doman wmmenu.1
	dodoc README TODO example/apps example/defaults example/extract_icon_back
}
