# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="client for the french tarot game maitretarot"
HOMEPAGE="http://www.nongnu.org/maitretarot/"
SRC_URI="https://savannah.nongnu.org/download/maitretarot/${PN}.pkg/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

DEPEND="dev-libs/glib:2
	dev-libs/libxml2
	dev-games/libmaitretarot
	dev-games/libmt_client
	gnome-base/libgnomeui
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}
	dev-games/cardpics"

PATCHES=(
	"${FILESDIR}"/${P}-formatsecurity.patch
)

src_configure() {
	econf $(use_enable gnome gnome2)
}
