# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="A game programming library"
HOMEPAGE="https://liballeg.org/"
SRC_URI="mirror://sourceforge/alleg/${P}.tar.gz"

LICENSE="BSD ZLIB"
SLOT="5"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="alsa dumb flac gtk jpeg openal oss physfs png pulseaudio test truetype vorbis X xinerama"

RDEPEND="
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXcursor-1.1.14[${MULTILIB_USEDEP}]
	>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXxf86vm-1.1.3[${MULTILIB_USEDEP}]
	>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
	>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	dumb? ( >=media-libs/dumb-0.9.3-r2[${MULTILIB_USEDEP}] )
	flac? ( >=media-libs/flac-1.2.1-r5[${MULTILIB_USEDEP}] )
	gtk? ( >=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}] )
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	openal? ( >=media-libs/openal-1.15.1[${MULTILIB_USEDEP}] )
	physfs? ( >=dev-games/physfs-2.0.3-r1[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.5.18:0[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	truetype? ( >=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}] )
	vorbis? ( >=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}] )
	xinerama? ( >=x11-libs/libXinerama-1.1.3[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	x11-base/xorg-proto
"

PATCHES=( "${FILESDIR}"/${P}-{underlink,multilib}.patch )

MULTILIB_WRAPPED_HEADERS=( /usr/include/allegro5/allegro_native_dialog.h )

src_configure() {
	local mycmakeargs=(
		-DWANT_ALSA=$(usex alsa)
		-DWANT_DEMO=OFF
		-DWANT_EXAMPLES=OFF
		-DWANT_FLAC=$(usex flac)
		-DWANT_IMAGE_JPG=$(usex jpeg)
		-DWANT_IMAGE_PNG=$(usex png)
		-DWANT_MODAUDIO=$(usex dumb)
		-DWANT_OPENAL=$(usex openal)
		-DWANT_OSS=$(usex oss)
		-DWANT_PHYSFS=$(usex physfs)
		-DWANT_PULSEAUDIO=$(usex pulseaudio)
		-DWANT_TESTS=$(usex test)
		-DWANT_TTF=$(usex truetype)
		-DWANT_VORBIS=$(usex vorbis)
		-DWANT_NATIVE_DIALOG=$(usex gtk)
		-DWANT_OPENGL=$(usex X)
		-DWANT_X11=$(usex X)
		-DWANT_X11_XINERAMA=$(usex xinerama)
	)

	cmake-multilib_src_configure
}

src_install() {
	local HTML_DOCS=( docs/html/refman/. )
	cmake-multilib_src_install

	dodoc CHANGES-5.0.txt
	doman docs/man/*.3
}
