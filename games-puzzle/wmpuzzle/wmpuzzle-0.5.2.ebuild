# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils games

DESCRIPTION="wmpuzzle provides a 4x4 puzzle on a 64x64 mini window"
HOMEPAGE="http://freecode.com/projects/wmpuzzle"
SRC_URI="http://people.debian.org/~godisch/wmpuzzle/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

S=${WORKDIR}/${P}/src

src_install() {
	dogamesbin ${PN}

	dodoc ../{CHANGES,README}
	newicon -s 48 numbers.xpm ${PN}.xpm
	doman ${PN}.6
	make_desktop_entry ${PN}

	prepgamesdirs
}

pkg_preinst() {
	gnome2_icon_savelist
	games_pkg_preinst
}

pkg_postinst() {
	gnome2_icon_cache_update
	games_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
}
