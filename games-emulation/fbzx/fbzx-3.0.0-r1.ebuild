# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop toolchain-funcs

DESCRIPTION="Full Screen Sinclair Spectrum emulator"
HOMEPAGE="https://github.com/rastersoft/fbzx"
SRC_URI="https://github.com/rastersoft/fbzx/archive/3.0.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[video]
	media-sound/pulseaudio
	media-libs/alsa-lib
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	sed -i -e "s|/usr/share/|/usr/share/${PN}/|g" src/llscreen.cpp || die

	tc-export PKG_CONFIG

	default
}

src_install() {
	dobin src/fbzx

	insinto /usr/share/${PN}
	doins -r data/{keymap.bmp,spectrum-roms}

	dodoc AMSTRAD CAPABILITIES FAQ PORTING README* TODO VERSIONS
	doicon data/fbzx.svg
	make_desktop_entry fbzx FBZX
}
