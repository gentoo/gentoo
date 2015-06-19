# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/pengupop/pengupop-2.2.5.ebuild,v 1.9 2015/02/08 09:34:57 ago Exp $

EAPI=5
inherit eutils gnome2-utils autotools games

DESCRIPTION="Networked multiplayer-only Puzzle Bubble clone"
HOMEPAGE="http://freshmeat.net/projects/pengupop"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlink.patch

	sed -i \
		-e '/Icon/s/\.png//' \
		-e '/^Encoding/d' \
		-e '/Categories/s/Application;//' \
		pengupop.desktop || die

	sed -i \
		-e 's/-g -Wall -O2/-Wall/' \
		Makefile.am || die
	mv configure.in configure.ac || die
	eautoreconf
}

src_install() {
	default
	domenu pengupop.desktop
	doicon -s 48 pengupop.png
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
