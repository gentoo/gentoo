# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools desktop

DESCRIPTION="Port of Abuse by Crack Dot Com"
HOMEPAGE="http://abuse.zoy.org/"
SRC_URI="http://abuse.zoy.org/raw-attachment/wiki/download/${P}.tar.gz"

LICENSE="GPL-2 WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.1.6[sound,opengl,video]
	media-libs/sdl-mixer
	virtual/opengl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo-r1.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Prevent segfault at start: https://bugs.archlinux.org/task/52915
	econf --enable-debug
}

src_install() {
	# Source-based install
	default

	doicon doc/${PN}.png
	make_desktop_entry abuse Abuse
}
