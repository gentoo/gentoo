# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/hexamine/hexamine-0.2.1.ebuild,v 1.6 2015/05/15 19:25:25 mr_bones_ Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 games

DESCRIPTION="Hexagonal Minesweeper"
HOMEPAGE="http://sourceforge.net/projects/hexamine"
SRC_URI="mirror://sourceforge/hexamine/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-python/pygame
	${PYTHON_DEPS}"
DEPEND="${PYTHON_DEPS}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${PN}

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	# Modify game data directory
	sed -i \
		-e "s:\`dirname \$0\`:${GAMES_DATADIR}/${PN}:" \
		-e "s:\./hexamine:exec ${EPYTHON} &:" \
		hexamine || die
}

src_install() {
	dogamesbin hexamine
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r hexamine.* skins
	dodoc ABOUT README
	prepgamesdirs
}
