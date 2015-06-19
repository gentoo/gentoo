# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/vor/vor-0.5.5.ebuild,v 1.6 2014/05/15 16:34:07 ulm Exp $

EAPI=5
inherit autotools eutils gnome2-utils games

DESCRIPTION="Variations on Rockdodger: Dodge the rocks until you die"
HOMEPAGE="http://jasonwoof.org/vor"
SRC_URI="http://qualdan.com/vor/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-underlink.patch"
	eautoreconf
}

src_install() {
	dodir "${GAMES_BINDIR}"
	DOCS="README* todo" default
	newicon -s 48 data/icon.png ${PN}.png
	make_desktop_entry ${PN} VoR
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
