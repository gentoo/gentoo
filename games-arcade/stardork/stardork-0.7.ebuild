# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/stardork/stardork-0.7.ebuild,v 1.4 2015/02/08 09:34:37 ago Exp $

EAPI=5
inherit toolchain-funcs games

DESCRIPTION="An ncurses-based space shooter"
HOMEPAGE="http://stardork.sourceforge.net/"
SRC_URI="mirror://sourceforge/stardork/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	rm -f Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS="$(pkg-config ncurses --libs)" ${PN}
}

src_install() {
	dogamesbin ${PN}
	dodoc README
	prepgamesdirs
}
