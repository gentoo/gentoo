# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Match rising tiles before reaching the top to score as many points as possible"
HOMEPAGE="http://www.shiftygames.com/torrent/torrent.html"
SRC_URI="http://www.shiftygames.com/torrent/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	>=media-libs/libsdl-1.2.4
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-image-1.2
	media-libs/sdl-ttf
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i \
		-e 's/inline void SE_CheckEvents/void SE_CheckEvents/' \
		src/torrent.c \
		|| die "sed failed"
}

src_install() {
	default
	newicon pics/sg_icon.png ${PN}.png
	make_desktop_entry ${PN} Torrent ${PN}
}
