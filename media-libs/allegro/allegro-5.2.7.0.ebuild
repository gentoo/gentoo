# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS="cmake"
inherit cmake-multilib

DESCRIPTION="Cross-platform library aimed at video game and multimedia programming"
HOMEPAGE="https://liballeg.org/"
SRC_URI="https://github.com/liballeg/allegro5/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD ZLIB"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
IUSE="alsa dumb flac gtk jpeg openal opengl opus oss physfs png pulseaudio test truetype vorbis webp X xinerama"
RESTRICT="!test? ( test )"

# TODO: For tests, we need some extra deps.
# -- Could NOT find OPENSL (missing: OPENSL_INCLUDE_DIR OPENSL_LIBRARY)
# -- Could NOT find MiniMP3 (missing: MINIMP3_INCLUDE_DIRS)
# TODO: Tweak REQUIRED_USE for tests?
# WARNING: allegro_video wanted but no supported backend found

REQUIRED_USE="X? ( opengl )
	xinerama? ( X )
	|| ( alsa openal oss pulseaudio )"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	dumb? ( >=media-libs/dumb-0.9.3-r2:=[${MULTILIB_USEDEP}] )
	flac? ( >=media-libs/flac-1.2.1-r5[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:3[${MULTILIB_USEDEP}] )
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	openal? ( >=media-libs/openal-1.15.1[${MULTILIB_USEDEP}] )
	opengl? (
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	)
	opus? ( media-libs/opus[${MULTILIB_USEDEP}] )
	physfs? ( >=dev-games/physfs-2.0.3-r1[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.5.18:0=[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	truetype? ( >=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}] )
	vorbis? ( >=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp:0=[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXcursor-1.1.14[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86vm-1.1.3[${MULTILIB_USEDEP}]
	)
	xinerama? ( >=x11-libs/libXinerama-1.1.3[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

MULTILIB_WRAPPED_HEADERS=( /usr/include/allegro5/allegro_native_dialog.h )

src_configure() {
	# We forego freeimage for now because ebuild is not multilib
	# No known consumers yet anyway
	local mycmakeargs=(
		-DWANT_ALSA=$(usex alsa)
		-DWANT_DEMO=OFF
		-DWANT_EXAMPLES=OFF
		-DWANT_FLAC=$(usex flac)
		-DWANT_IMAGE_FREEIMAGE=OFF
		-DWANT_IMAGE_JPG=$(usex jpeg)
		-DWANT_IMAGE_PNG=$(usex png)
		-DWANT_IMAGE_WEBP=$(usex webp)
		-DWANT_MODAUDIO=$(usex dumb)
		-DWANT_NATIVE_DIALOG=$(usex gtk)
		-DWANT_OGG_VIDEO=$(usex vorbis)
		-DWANT_OPENAL=$(usex openal)
		-DWANT_OPENGL=$(usex opengl)
		-DWANT_OPUS=$(usex opus)
		-DWANT_OSS=$(usex oss)
		-DWANT_PHYSFS=$(usex physfs)
		-DWANT_PRIMITIVES=$(usex opengl)
		-DWANT_PULSEAUDIO=$(usex pulseaudio)
		-DWANT_TESTS=$(usex test)
		-DWANT_TTF=$(usex truetype)
		-DWANT_VORBIS=$(usex vorbis)
		-DWANT_X11=$(usex X)
		-DWANT_X11_XINERAMA=$(usex xinerama)
	)

	cmake-multilib_src_configure
}

src_install() {
	local HTML_DOCS=( docs/html/refman/. )
	cmake-multilib_src_install

	dodoc CHANGES-5.0.txt CHANGES-5.1.txt CHANGES-5.2.txt
	doman docs/man/*.3
}
