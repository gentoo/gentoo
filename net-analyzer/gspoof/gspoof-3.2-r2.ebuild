# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/gspoof/gspoof-3.2-r2.ebuild,v 1.3 2012/06/08 12:03:49 phajdan.jr Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="A simple GTK/command line TCP/IP packet generator"
HOMEPAGE="http://gspoof.sourceforge.net/"
SRC_URI="http://gspoof.sourceforge.net/src/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

IUSE=""

DEPEND="
	x11-libs/gtk+:2
	dev-libs/glib:2
	net-libs/libnet:1.1
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-def-values.patch \
		"${FILESDIR}"/${P}-icon.patch
	sed -i configure.ac -e 's|libnet.a|libnet.so|g' || die
	eautoreconf
}

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin gspoof
	newicon pixmap/icon.png ${PN}.png
	dodoc README CHANGELOG TODO
}
