# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="Opening book for gnuchess"
HOMEPAGE="http://www.gnu.org/software/chess/chess.html"
SRC_URI="mirror://gnu/chess/book_${PV}.pgn.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""
RESTRICT="userpriv" # bug #112898

DEPEND=">=games-board/gnuchess-6"
RDEPEND=${DEPEND}

S=${WORKDIR}

src_compile() {
	"${GAMES_BINDIR}"/gnuchess --addbook=book_${PV}.pgn || die
}

src_install() {
	insinto "${GAMES_DATADIR}/gnuchess"
	doins book.bin
	prepgamesdirs
}
