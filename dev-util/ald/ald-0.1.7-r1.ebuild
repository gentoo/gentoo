# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ald/ald-0.1.7-r1.ebuild,v 1.1 2012/10/18 10:06:40 pinkbyte Exp $

EAPI="4"

inherit autotools

DESCRIPTION="Assembly Language Debugger - a tool for debugging executable programs at the assembly level"
HOMEPAGE="http://ald.sourceforge.net/"
SRC_URI="mirror://sourceforge/ald/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug ncurses"

DEPEND="ncurses? ( sys-libs/ncurses )"
RDEPEND="${DEPEND}"

DOCS=( BUGS ChangeLog README TODO )

src_prepare() {
	# respect CFLAGS (bug #240268)
	sed -i -e "/^CFLAGS/d" configure.ac || die 'sed on CFLAGS failed'

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable ncurses curses) \
		$(use_enable debug assert)
}
