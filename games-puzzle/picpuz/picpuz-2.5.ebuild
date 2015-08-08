# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils gnome2-utils games

DESCRIPTION="A jigsaw puzzle program"
HOMEPAGE="http://kornelix.squarespace.com/picpuz/"
SRC_URI="http://kornelix.squarespace.com/storage/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-build.patch "${FILESDIR}"/${P}-pthread-underlinking.patch )

src_compile() {
	emake \
		BINDIR="${GAMES_BINDIR}" \
		DATADIR="${GAMES_DATADIR}"/${PN} \
		DOCDIR=/usr/share/doc/${PF}/html
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r icons locales
	doicon -s 48 icons/${PN}.png
	make_desktop_entry ${PN} Picpuz
	dohtml -r doc/{userguide-en.html,images}
	dodoc doc/{changelog,README,translations}
	newman doc/${PN}.man ${PN}.1
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
