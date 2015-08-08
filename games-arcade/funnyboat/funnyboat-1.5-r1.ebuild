# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils gnome2-utils python-single-r1 games

DESCRIPTION="A side scrolling shooter game starring a steamboat on the sea"
HOMEPAGE="http://funnyboat.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=dev-python/pygame-1.6.2[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	app-arch/unzip"

S=${WORKDIR}/${PN}

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data *.py
	python_optimize "${ED%/}/${GAMES_DATADIR}"/${PN}

	dodoc *.txt
	games_make_wrapper ${PN} "${EPYTHON} main.py" "${GAMES_DATADIR}"/${PN}
	newicon -s 32 data/kuvake.png ${PN}.png
	make_desktop_entry ${PN} "Trip on the Funny Boat"
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
