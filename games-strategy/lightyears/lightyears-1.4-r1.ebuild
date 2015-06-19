# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/lightyears/lightyears-1.4-r1.ebuild,v 1.5 2015/06/08 21:30:13 mr_bones_ Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 games

DESCRIPTION="a single-player game with a science-fiction theme"
HOMEPAGE="http://www.jwhitham.org/20kly/"
SRC_URI="http://www.jwhitham.org/20kly/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/pygame[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
RDEPEND=${DEPEND}
REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_prepare() {
	epatch "${FILESDIR}/${P}"-gentoo.patch
	sed -i \
		-e "s:@GENTOO_LIBDIR@:$(games_get_libdir)/${PN}:" \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		${PN} || die
	python_fix_shebang .
}

src_install() {
	dogamesbin ${PN}

	insinto "$(games_get_libdir)/${PN}"
	doins code/*.py

	dodoc README.txt

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r audio data manual

	python_optimize "${D}$(games_get_libdir)/${PN}"

	newicon data/32.png ${PN}.png
	make_desktop_entry ${PN} "Light Years Into Space"
	prepgamesdirs
}

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}
