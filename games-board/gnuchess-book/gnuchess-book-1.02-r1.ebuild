# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Opening book for gnuchess"
HOMEPAGE="https://www.gnu.org/software/chess/chess.html"
SRC_URI="mirror://gnu/chess/book_${PV}.pgn.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""
RESTRICT="userpriv" # bug #112898

DEPEND=">=games-board/gnuchess-6.2.3"
RDEPEND=${DEPEND}

S=${WORKDIR}

src_compile() {
	gnuchess --addbook=book_${PV}.pgn || die
}

src_install() {
	insinto /usr/share/gnuchess
	doins book.bin
}
