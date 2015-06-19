# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/fe/fe-1.8.ebuild,v 1.5 2011/08/27 19:12:54 ulm Exp $

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
	epatch "${FILESDIR}/${P}-makefile.patch"
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
