# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/robotfindskitten/robotfindskitten-1.7320508.406.ebuild,v 1.6 2015/02/06 21:50:13 tupone Exp $
EAPI=5
inherit games

DESCRIPTION="Help robot find kitten"
HOMEPAGE="http://robotfindskitten.org/"
SRC_URI="mirror://sourceforge/rfk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_install() {
	dogamesbin src/robotfindskitten
	doinfo doc/robotfindskitten.info
	dodoc AUTHORS BUGS ChangeLog NEWS README
	prepgamesdirs
}
