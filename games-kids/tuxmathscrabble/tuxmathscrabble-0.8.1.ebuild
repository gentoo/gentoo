# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 multilib games

MY_PN=TuxMathScrabble
DESCRIPTION="math-version of the popular board game for children 4-10"
HOMEPAGE="http://www.asymptopia.org/"
SRC_URI="https://github.com/asymptopia/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

CDEPEND="${PYTHON_DEPS}
	dev-python/wxpython[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	app-arch/unzip"
RDEPEND="${CDEPEND}
	dev-python/pygame[${PYTHON_USEDEP}]"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	rm -f $(find . -name '*.pyc')
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${MY_PN}:" \
		${MY_PN}/tms.py \
		.tms_config_master \
		|| die "sed failed"
	sed -i \
		-e "s:python2.7-32:python:g" \
		${PN}.py || die "2nd sed failed"
	python_fix_shebang .
}

src_install() {
	newgamesbin ${PN}.py ${PN}

	insinto $(python_get_sitedir)
	doins -r ${MY_PN}

	insinto "${GAMES_DATADIR}"/${MY_PN}
	doins -r .tms_config_master Font

	python_optimize

	newicon tms.ico ${PN}.ico
	make_desktop_entry ${PN} ${PN} /usr/share/pixmaps/${PN}.ico

	dodoc CHANGES README
	prepgamesdirs
}
