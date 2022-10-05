# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="Match rising tiles before reaching the top to score as many points as possible"
HOMEPAGE="http://www.shiftygames.com/torrent/torrent.html"
SRC_URI="http://www.shiftygames.com/torrent/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=media-libs/libsdl-1.2.4
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-image-1.2
	media-libs/sdl-ttf
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.2-Fix-function-prototypes-inline-link-issue.patch
)

src_prepare() {
	default

	# Needed for Clang 16+ to flush out stale configure
	eautoreconf
}

src_install() {
	default

	newicon pics/sg_icon.png ${PN}.png
	make_desktop_entry ${PN} Torrent ${PN}
}
