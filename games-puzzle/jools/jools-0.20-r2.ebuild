# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 games

MUS_P=${PN}-musicpack-1.0
DESCRIPTION="clone of Bejeweled, a popular pattern-matching game"
HOMEPAGE="http://pessimization.com/software/jools/"
SRC_URI="http://pessimization.com/software/jools/${P}.tar.gz
	 http://pessimization.com/software/jools/${MUS_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-python/pygame[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
RDEPEND=${DEPEND}
REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/${P}/jools

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"/music
	unpack ${MUS_P}.tar.gz
}

src_prepare() {
	echo "MEDIAROOT = \"${GAMES_DATADIR}/${PN}\"" > config.py
	python_fix_shebang .
}

src_install() {
	games_make_wrapper ${PN} "${EPYTHON} ./__init__.py" "$(games_get_libdir)"/${PN}
	insinto "$(games_get_libdir)"/${PN}
	doins *.py
	python_optimize "${D}$(games_get_libdir)/${PN}"

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r fonts images music sounds

	newicon images/ruby/0001.png ${PN}.png
	make_desktop_entry ${PN} Jools
	dodoc ../{ChangeLog,doc/{POINTS,TODO}}
	dohtml ../doc/manual.html
	prepgamesdirs
}
