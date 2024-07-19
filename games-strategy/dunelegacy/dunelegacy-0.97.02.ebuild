# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop xdg

DESCRIPTION="Updated clone of Westood Studios' Dune II"
HOMEPAGE="https://dunelegacy.sourceforge.net"

COMMIT="6ea9ac96854daa8c75ba429e78dc6716b147e106"
SRC_URI="https://sourceforge.net/code-snapshots/git/d/du/${PN}/code.git/${PN}-code-${COMMIT}.zip -> ${P}.zip"
S="${WORKDIR}/${PN}-code-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86"

RDEPEND="
	media-libs/libsdl2[sound,threads(+),video]
	media-libs/sdl2-mixer[midi]
	media-libs/sdl2-ttf
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-flickering.patch
	"${FILESDIR}"/${P}-text-manager.patch
)

src_prepare() {
	default
	eautoreconf

	sed -i s/0.96.4/0.97.02/ configure.ac || die
}

src_install() {
	default

	doicon -s scalable ${PN}.svg
	doicon -s 48 ${PN}.png
	newicon -s 128 ${PN}-128x128.png ${PN}.png
	make_desktop_entry ${PN} "Dune Legacy"
}
