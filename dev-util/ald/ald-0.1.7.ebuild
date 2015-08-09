# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Assembly Language Debugger - a tool for debugging executable programs at the assembly level"
HOMEPAGE="http://ald.sourceforge.net/"
SRC_URI="mirror://sourceforge/ald/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="ncurses"

DEPEND="ncurses? ( sys-libs/ncurses )"
RDEPEND="${DEPEND}"

src_compile() {
	econf $(use_enable ncurses curses)
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README ChangeLog TODO BUGS
}
