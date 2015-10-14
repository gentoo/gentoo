# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games eutils

DESCRIPTION="client for the french tarot game maitretarot"
HOMEPAGE="http://www.nongnu.org/maitretarot/"
SRC_URI="http://savannah.nongnu.org/download/maitretarot/${PN}.pkg/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome"

DEPEND="dev-libs/glib:2
	dev-libs/libxml2
	dev-games/libmaitretarot
	dev-games/libmt_client
	gnome-base/libgnomeui
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}
	dev-games/cardpics"

src_prepare() {
	epatch "${FILESDIR}"/${P}-formatsecurity.patch
}

src_configure() {
	egamesconf $(use_enable gnome gnome2)
}

src_install() {
	default
	if [[ -d "${D}"/${GAMES_DATADIR}/locale ]] ; then
		mv "${D}"/${GAMES_DATADIR}/locale "${D}"/usr/share/ || die
	fi
	prepgamesdirs
}
