# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A Sokoban-styled puzzle game with lots more action"
HOMEPAGE="http://xpired.sourceforge.net"
SRC_URI="mirror://sourceforge/xpired/${P}-linux_source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="media-libs/sdl-gfx
	media-libs/sdl-image[jpeg]
	media-libs/sdl-mixer[mod]"
RDEPEND=${DEPEND}

S=${WORKDIR}/src

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	emake \
		PREFIX=/usr/games \
		SHARE_PREFIX=/usr/share/games/xpired
}

src_install() {
	emake \
		PREFIX="${D}/usr/games" \
		SHARE_PREFIX="${D}/usr/share/games/${PN}" \
		install
	newicon img/icon.bmp ${PN}.bmp
	make_desktop_entry xpired Xpired /usr/share/pixmaps/${PN}.bmp
	make_desktop_entry xpiredit "Xpired Level Editor"
	prepgamesdirs
}
