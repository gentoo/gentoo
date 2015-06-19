# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/openbubbles/openbubbles-1.2.ebuild,v 1.8 2015/01/05 16:02:22 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A clone of Evan Bailey's game Bubbles"
HOMEPAGE="http://www.freewebs.com/lasindi/openbubbles/index.html"
SRC_URI="http://www.freewebs.com/lasindi/openbubbles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-gfx"
RDEPEND="${DEPEND}"
PATCHES=( "${FILESDIR}"/${P}-glibc2.10.patch )

src_install() {
	default
	newicon data/bubble.png ${PN}.png
	make_desktop_entry ${PN} "OpenBubbles"
	prepgamesdirs
}
