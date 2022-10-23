# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop toolchain-funcs

DESCRIPTION="Robbo, a popular Atari XE/XL game ported to Linux"
HOMEPAGE="http://gnurobbo.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/gnurobbo/${P}-source.tar.gz
	https://salsa.debian.org/games-team/gnurobbo/-/raw/debian/$(ver_cut 1-2)+dfsg-5/debian/patches/single-variable-declarations.patch?inline=false -> ${P}-single-variable-declarations.patch
"

LICENSE="GPL-2 BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}/${P}/${PN}"

RDEPEND="
	media-libs/libsdl[sound,video,joystick]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-flags.patch"
	"${DISTDIR}/${P}-single-variable-declarations.patch"
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		PACKAGE_DATA_DIR="${EPREFIX}/usr/share/${PN}"
}

src_install() {
	dobin gnurobbo
	insinto "/usr/share/${PN}"
	doins -r data/{levels,skins,locales,rob,sounds}
	dodoc AUTHORS Bugs ChangeLog README TODO
	newicon icon32.png ${PN}.png
	make_desktop_entry ${PN} Gnurobbo
}
