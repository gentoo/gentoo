# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A small command-line based Direct Connect client"
HOMEPAGE="http://www.nongnu.org/microdc/"
SRC_URI="http://savannah.nongnu.org/download/microdc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND="sys-libs/ncurses
	>=sys-libs/readline-4
	nls? ( sys-devel/gettext )"

src_compile() {
	econf $(use_enable nls) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README doc/*
}
