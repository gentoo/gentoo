# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/fe/fe-1.9.ebuild,v 1.3 2012/06/08 11:49:36 phajdan.jr Exp $

EAPI=4

inherit eutils

DESCRIPTION="A small and easy to use folding editor"
HOMEPAGE="http://www.moria.de/~michael/fe/"
SRC_URI="http://www.moria.de/~michael/fe/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="sendmail"

DEPEND="sys-libs/ncurses
	sendmail? ( virtual/mta )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.8-makefile.patch"
}

src_configure() {
	econf $(use_enable sendmail)
}

src_install() {
	emake \
		prefix="${D}"/usr \
		datadir="${D}"/usr/share \
		MANDIR="${D}"/usr/share/man \
		install

	dodoc NEWS README
	dohtml fe.html
}
