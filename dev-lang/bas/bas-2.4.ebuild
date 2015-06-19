# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/bas/bas-2.4.ebuild,v 1.1 2013/08/26 10:14:44 patrick Exp $

EAPI=4
inherit autotools eutils toolchain-funcs

DESCRIPTION="An interpreter for the classic dialect of the programming language BASIC"
HOMEPAGE="http://www.moria.de/~michael/bas/"
SRC_URI="http://www.moria.de/~michael/bas/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lr0"

RDEPEND="sys-libs/ncurses
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-2.1-makefile.patch

	eautoconf
}

src_configure() {
	tc-export AR
	econf \
		$(use_enable lr0)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc NEWS README
	insinto /usr/share/doc/${PF}/pdf
	doins bas.pdf
}
