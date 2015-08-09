# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 games

DESCRIPTION="Quiet Console Town puts you in the place of the mayor of a budding new console RPG city"
HOMEPAGE="http://packages.gentoo.org/package/games-simulation/qct"
SRC_URI="http://www.sourcefiles.org/Games/Role_Play/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=dev-python/pygame-1.5.5[${PYTHON_USEDEP}]"
RDEPEND=${RDEPEND}
REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-constant.patch
	python_fix_shebang .
}

src_install() {
	# Ug.  Someone fix this to install in $(games_get_libdir)/${PN} instead
	local destdir="${GAMES_DATADIR}/${PN}"
	insinto "${destdir}"
	exeinto "${destdir}"

	dodoc README
	doins *.py *.png
	doexe qct.py

	python_optimize "${D}${GAMES_DATADIR}/${PN}"

	games_make_wrapper qct "./qct.py" "${destdir}"

	prepgamesdirs
}

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}
