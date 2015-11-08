# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic games

DESCRIPTION="Console based chess interface"
HOMEPAGE="https://www.gnu.org/software/chess/chess.html"
SRC_URI="mirror://gnu/chess/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

PATCHES=( "${FILESDIR}"/${P}-addbook.patch )

src_configure() {
	strip-flags # bug #199097
	egamesconf --without-readline # bug 491088
}

src_install () {
	default
	prepgamesdirs
}
