# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/concentration/concentration-1.2-r1.ebuild,v 1.8 2015/03/28 05:06:51 mr_bones_ Exp $

EAPI=5
inherit eutils games

DESCRIPTION="The classic memory game with some new life"
HOMEPAGE="https://packages.gentoo.org/package/games-puzzle/concentration"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-ttf"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	default
	newicon pics/set1/19.png ${PN}.png
	make_desktop_entry ${PN} Concentration
	prepgamesdirs
}
