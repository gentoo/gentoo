# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="simple arcade racing game"
HOMEPAGE="http://www.linux-games.com/bumprace/"
SRC_URI="http://user.cs.tu-berlin.de/~karlb/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[gif,jpeg,png]
	media-libs/sdl-mixer[mod]
	virtual/jpeg:0
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_install() {
	default
	make_desktop_entry bumprace BumpRace
}
