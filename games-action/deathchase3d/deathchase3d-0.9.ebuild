# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=4

inherit games

DESCRIPTION="A remake of the Sinclair Spectrum game of the same name"
HOMEPAGE="http://www.autismuk.freeserve.co.uk/"
SRC_URI="http://www.autismuk.freeserve.co.uk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="media-libs/libsdl"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-underlink.patch )

src_install() {
	dogamesbin "${PN}/${PN}"
	dodoc README
	dohtml "${PN}/docs/en/index.html"
	prepgamesdirs
}
