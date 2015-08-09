# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 games

MY_PV=${PV//./}
MY_P=${PN}_b${MY_PV}
DESCRIPTION="A traditional and challenging 2D platformer game with a slight rotational twist"
HOMEPAGE="http://hectigo.net/puskutraktori/whichwayisup/"
SRC_URI="http://hectigo.net/puskutraktori/whichwayisup/${MY_P}.zip"

LICENSE="GPL-2 CC-BY-3.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-python/pygame[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-arch/unzip"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/${PN}

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	sed -i \
		-e "s:libdir\ =\ .*:libdir\ =\ \"$(games_get_libdir)/${PN}\":" \
		run_game.py || die
	sed -i \
		-e "s:data_dir\ =\ .*:data_dir\ =\ \"${GAMES_DATADIR}/${PN}\":" \
		lib/data.py || die
	rm data/pictures/Thumbs.db
	python_fix_shebang .
}

src_install() {
	newgamesbin run_game.py ${PN}

	insinto "$(games_get_libdir)/${PN}"
	doins lib/*.py

	python_optimize "${D}$(games_get_libdir)/${PN}"

	dodoc README.txt changelog.txt

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/*

	newicon "${FILESDIR}"/${PN}-32.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Which Way Is Up?"
	prepgamesdirs
}
