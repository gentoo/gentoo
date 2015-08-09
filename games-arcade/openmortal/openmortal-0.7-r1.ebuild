# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="A spoof of the famous Mortal Kombat game"
HOMEPAGE="http://openmortal.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/sdl-net
	>=media-libs/freetype-2.4.0
	dev-lang/perl"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}"-gcc41.patch \
		"${FILESDIR}/${P}"-freetype.patch

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	newicon data/gfx/icon.png ${PN}.png
	make_desktop_entry ${PN} OpenMortal
	dodoc AUTHORS ChangeLog README TODO
	prepgamesdirs
}
