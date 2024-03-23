# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="Assembly Language Debugger"
HOMEPAGE="http://ald.sourceforge.net/"
SRC_URI="mirror://sourceforge/ald/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="debug ncurses"

DEPEND="ncurses? ( sys-libs/ncurses:= )"
RDEPEND="${DEPEND}"

src_prepare() {
	# respect CFLAGS (bug #240268)
	sed -i -e "/^CFLAGS/d" configure.ac || die 'sed on CFLAGS failed'
	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable ncurses curses) \
		$(use_enable debug assert)
}
