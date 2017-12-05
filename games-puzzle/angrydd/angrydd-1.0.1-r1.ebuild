# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 games

DESCRIPTION="Angry, Drunken Dwarves, a falling blocks game similar to Puzzle Fighter"
HOMEPAGE="https://www.sacredchao.net/~piman/angrydd/"
SRC_URI="https://www.sacredchao.net/~piman/angrydd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygame[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
RDEPEND=${DEPEND}
REQUIRED_USE=${PYTHON_REQUIRED_USE}

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	python_fix_shebang .
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${GAMES_DATADIR}" \
		TO="${PN}" \
		install
	rm -rf "${D}${GAMES_DATADIR}/games" "${D}${GAMES_DATADIR}/share" || die

	python_optimize "${D}${GAMES_DATADIR}/${PN}"

	dodir "${GAMES_BINDIR}"
	dosym "${GAMES_DATADIR}/${PN}/angrydd.py" "${GAMES_BINDIR}/${PN}"
	doman angrydd.6
	dodoc README TODO HACKING

	doicon angrydd.png
	make_desktop_entry angrydd "Angry, Drunken Dwarves"

	prepgamesdirs
}
