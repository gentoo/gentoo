# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Clone of Evan Bailey's game Bubbles"
HOMEPAGE="https://web.archive.org/web/20101126190910/http://www.freewebs.com/lasindi/openbubbles/"
SRC_URI="https://web.archive.org/web/20101126190910/http://www.freewebs.com/lasindi/openbubbles/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-gfx"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-glibc2.10.patch )

src_install() {
	default
	newicon data/bubble.png ${PN}.png
	make_desktop_entry ${PN} "OpenBubbles"
}
