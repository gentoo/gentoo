# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/biloba/biloba-0.9.3.ebuild,v 1.8 2014/10/10 15:25:42 ago Exp $

EAPI=5
inherit autotools eutils gnome2-utils games

DESCRIPTION="a board game, up to 4 players, with AI and network"
HOMEPAGE="http://biloba.sourceforge.net/"
SRC_URI="mirror://sourceforge/biloba/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl:0[X,video,sound]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer"
RDEPEND=${DEPEND}

src_prepare() {
	# X11 headers are checked but not used, everything is done through SDL
	epatch \
		"${FILESDIR}"/${P}-not-windows.patch \
		"${FILESDIR}"/${P}-no-X11-dep.patch

	# "missing" file is old, and warns about --run not being supported
	rm -f missing
	eautoreconf
}

src_install() {
	default
	newicon -s 64 biloba_icon.png ${PN}.png
	make_desktop_entry biloba Biloba
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
