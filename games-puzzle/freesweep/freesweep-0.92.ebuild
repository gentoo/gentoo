# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/freesweep/freesweep-0.92.ebuild,v 1.7 2014/10/31 02:01:18 mr_bones_ Exp $

EAPI=5
inherit toolchain-funcs games

DESCRIPTION="Console Minesweeper"
HOMEPAGE="http://freshmeat.net/projects/freesweep"
SRC_URI="http://www.upl.cs.wisc.edu/~hartmann/sweep/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~ppc-macos"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	emake LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	dogamesbin freesweep
	dodoc README
	doman freesweep.6
	prepgamesdirs
}
