# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Full Screen Sinclair Spectrum emulator"
HOMEPAGE="http://www.rastersoft.com/programas/fbzx.html"
SRC_URI="http://www.rastersoft.com/descargas/fbzx/${PN}_${PV}.tar.bz2"
S="${WORKDIR}/${PN}_${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa pulseaudio"

RDEPEND="
	media-libs/libsdl2[joystick,video]
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-joystick-invert.patch
	"${FILESDIR}"/${P}-makefile.patch
)

src_prepare() {
	default

	sed -i "s|/usr/share|${EPREFIX}/usr/share/${PN}|" src/llscreen.cpp || die
}

src_compile() {
	tc-export CXX PKG_CONFIG

	emake ALSA=$(usex alsa) PULSE=$(usex pulseaudio)
}

src_install() {
	dobin src/${PN}
	dodoc AMSTRAD CAPABILITIES FAQ HISTORY.md README.{TZX,md} TODO
	doicon data/${PN}.svg
	domenu data/${PN}.desktop

	insinto /usr/share/${PN}
	doins -r data/spectrum-roms

	insinto /usr/share/${PN}/${PN}
	doins data/keymap.bmp
}
