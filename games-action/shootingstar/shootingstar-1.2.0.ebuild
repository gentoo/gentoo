# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/shootingstar/shootingstar-1.2.0.ebuild,v 1.10 2015/02/06 13:41:29 ago Exp $

EAPI=5
inherit autotools eutils gnome2-utils games

DESCRIPTION="A topdown shooter"
HOMEPAGE="http://linux.softpedia.com/get/GAMES-ENTERTAINMENT/Arcade/Shooting-Star-19754.shtml"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl[video]
	media-libs/sdl-mixer
	media-libs/sdl-image"
RDEPEND=${DEPEND}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-gcc34.patch \
		"${FILESDIR}"/${P}-gcc44.patch
	eautoreconf
}

src_install () {
	default
	newicon -s 128 data/textures/body1.png ${PN}.png
	make_desktop_entry ${PN} "Shooting Star"
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
