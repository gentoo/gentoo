# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs vcs-clean

DESCRIPTION="Swap and match 3 or more jewels in a line in order to score points"
HOMEPAGE="https://www.linuxmotors.com/linux/gljewel/"
SRC_URI="https://www.linuxmotors.com/linux/gljewel/downloads/SDL_jewels-${PV}.tgz"
S="${WORKDIR}/SDL_jewels-${PV}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="
	media-libs/libsdl[opengl,video]
	media-libs/libglvnd[X]
"

DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_prepare() {
	default

	# fix the data dir locations as it looks to be intended to run from src dir
	sed -i -e "s|\"data\"|\"${EPREFIX}/usr/share/${PN}\"|" sound.c || die
	sed -i -e "s|data/bigfont.ppm|${EPREFIX}/usr/share/${PN}/bigfont.ppm|" gljewel.c || die
	ecvs_clean
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin gljewel

	insinto /usr/share/${PN}
	doins -r data/*

	einstalldocs
	make_desktop_entry gljewel SDL_jewels
}
