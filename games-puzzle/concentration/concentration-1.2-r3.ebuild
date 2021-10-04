# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="The classic memory game with some new life"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}
	!sci-biology/unafold"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_install() {
	default

	newicon pics/set1/19.png ${PN}.png
	make_desktop_entry ${PN} ${PN^}
}
