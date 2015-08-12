# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# There's already a "hexedit" package in the tree, so name this one differently

EAPI="5"

inherit toolchain-funcs

MY_P=${P/curses-}
DESCRIPTION="full screen curses hex editor (with insert/delete support)"
HOMEPAGE="http://www.rogoyski.com/adam/programs/hexedit/"
SRC_URI="http://www.rogoyski.com/adam/programs/hexedit/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	# Package has an old configure script.
	CONFIG_SHELL="/bin/bash"
	tc-export CC
	econf --program-prefix=curses-
}
