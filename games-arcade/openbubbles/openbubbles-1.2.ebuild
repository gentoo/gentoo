# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A clone of Evan Bailey's game Bubbles"
HOMEPAGE="https://web.archive.org/web/20101126190910/http://www.freewebs.com/lasindi/openbubbles/"
SRC_URI="https://web.archive.org/web/20101126190910/http://www.freewebs.com/lasindi/openbubbles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-gfx"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-glibc2.10.patch
}

src_install() {
	default
	newicon data/bubble.png ${PN}.png
	make_desktop_entry ${PN} "OpenBubbles"
	prepgamesdirs
}
