# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/ninvaders/ninvaders-0.1.1.ebuild,v 1.7 2015/01/05 15:38:53 tupone Exp $
EAPI=5
inherit toolchain-funcs games

DESCRIPTION="ASCII space invaders clone"
HOMEPAGE="http://ninvaders.sourceforge.net/"
SRC_URI="mirror://sourceforge/ninvaders/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}"
}

src_install() {
	newgamesbin nInvaders ninvaders
	dodoc README
	prepgamesdirs
}
