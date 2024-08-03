# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Simple arcade racing game"
HOMEPAGE="https://www.linux-games.com/bumprace/"
SRC_URI="https://github.com/karlb/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libjpeg-turbo:=
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[gif,jpeg,png]
	media-libs/sdl-mixer[mod]
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_install() {
	default
	make_desktop_entry bumprace BumpRace
}
