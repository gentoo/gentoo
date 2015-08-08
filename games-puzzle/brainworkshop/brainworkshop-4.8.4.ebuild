# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils gnome2-utils python-r1 games

DESCRIPTION="Short-term-memory training N-Back game"
HOMEPAGE="http://brainworkshop.sourceforge.net/"
SRC_URI="mirror://sourceforge/brainworkshop/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-python/pyopenal
	|| ( >=dev-python/pyglet-1.1.4[openal]
		 >=dev-python/pyglet-1.1.4[alsa] )"
DEPEND="app-arch/unzip"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-paths.patch
	edos2unix ${PN}.pyw

	sed -i \
		-e 's#@GENTOO_DATADIR@#'${GAMES_DATADIR}'#' \
		${PN}.pyw || die
}

src_install() {
	newgamesbin ${PN}.pyw ${PN}
	python_replicate_script "${D}${GAMES_BINDIR}"/${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r res/*
	dodoc Readme.txt data/Readme-stats.txt
	newicon -s 48 res/misc/brain/brain.png ${PN}.png
	make_desktop_entry ${PN} "Brain Workshop"
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
