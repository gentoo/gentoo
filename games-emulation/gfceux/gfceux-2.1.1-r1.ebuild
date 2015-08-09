# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2-utils distutils-r1 games

DESCRIPTION="A graphical frontend for the FCEUX emulator"
HOMEPAGE="http://fceux.com"
SRC_URI="mirror://sourceforge/fceultra/fceux-${PV}.src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/pygtk"
RDEPEND="${DEPEND}
	games-emulation/fceux"

S=${WORKDIR}/${PN}

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -i \
		-e "s#data/gfceux.glade#${GAMES_DATADIR}/${PN}/gfceux.glade#" \
		src/main.py || die
}

python_install() {
	distutils-r1_python_install --install-scripts="${GAMES_BINDIR}"
}

src_prepare() {
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install

	doicon -s 48 data/${PN}.png
	newicon -s 128 data/${PN}_big.png ${PN}.png

	# respect games variables
	dodir "${GAMES_DATADIR}"/${PN}
	mv "${ED}"/usr/share/${PN}/* "${ED}${GAMES_DATADIR}"/${PN}/ || die

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
