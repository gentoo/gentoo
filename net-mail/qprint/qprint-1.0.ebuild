# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/qprint/qprint-1.0.ebuild,v 1.8 2012/10/23 23:02:28 ulm Exp $

DESCRIPTION="MIME quoted-printable data encoding and decoding utility"
HOMEPAGE="http://www.fourmilab.ch/webtools/qprint/"
SRC_URI="http://www.fourmilab.ch/webtools/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~ppc-macos"
IUSE=""

DEPEND=""

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	make DESTDIR=${D} install || die "make install failed"
	dodoc COPYING INSTALL README *.html qprint.pdf qprint.w logo.gif
}
