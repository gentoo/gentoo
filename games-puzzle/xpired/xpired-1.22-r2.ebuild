# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Sokoban-styled puzzle game with lots more action"
HOMEPAGE="https://www.online-siesta.com/game/x-pired/"
SRC_URI="https://downloads.sourceforge.net/xpired/${P}-linux_source.tar.gz"
S="${WORKDIR}/src"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-gfx
	media-libs/sdl-image[jpeg]
	media-libs/sdl-mixer[mod]
"

RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
)

src_compile() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		SHARE_PREFIX="${EPREFIX}/usr/share/${PN}" \
		CC="$(tc-getCC)"
}

src_install() {
	emake install \
		PREFIX="${ED}/usr" \
		SHARE_PREFIX="${ED}/usr/share/${PN}"

	newicon img/icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} X-pired /usr/share/pixmaps/${PN}.bmp
	make_desktop_entry ${PN}it "X-pired Level Editor" /usr/share/pixmaps/${PN}.bmp

	einstalldocs
}
