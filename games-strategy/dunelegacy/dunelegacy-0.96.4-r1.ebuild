# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Updated clone of Westood Studios' Dune II"
HOMEPAGE="https://dunelegacy.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}-src.tar.bz2"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"

RDEPEND="
	media-libs/libsdl2[sound,threads(+),video]
	media-libs/sdl2-mixer[midi]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-init-mid.patch
)

src_prepare() {
	default

	# Prepend upstream flags.
	sed -i -r 's/^(C.*FLAGS)=[^$]+$/\0" ${\1}"/' configure || die
}

src_install() {
	default

	doicon -s scalable ${PN}.svg
	doicon -s 48 ${PN}.png
	newicon -s 128 ${PN}-128x128.png ${PN}.png
	make_desktop_entry ${PN} "Dune Legacy"
}
