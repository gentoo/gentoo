# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit toolchain-funcs python-any-r1

MY_P=${PN}${PV/./}
DESCRIPTION="Multiple Arcade Machine Emulator"
HOMEPAGE="https://github.com/mamedev/mame"
SRC_URI="https://github.com/mamedev/mame/archive/refs/tags/${MY_P}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-${MY_P}

LICENSE="BSD BSD-2 CC0-1.0 GPL-2+ LGPL-2.1+ MIT public-domain"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-arch/zstd
	dev-libs/expat
	dev-libs/libutf8proc:=
	dev-libs/pugixml
	dev-qt/qtbase:6=
	media-libs/flac:=
	media-libs/fontconfig
	media-libs/libglvnd
	media-libs/libjpeg-turbo:=
	media-libs/libpulse
	media-libs/libsdl3
	media-libs/portaudio
	media-libs/portmidi
	media-libs/sdl3-ttf
	media-video/pipewire
	sys-devel/gcc:*[cxx]
	virtual/zlib:=
	x11-libs/libX11
	x11-libs/libXi
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	dev-cpp/asio
"

DOCS=( README.md )

src_prepare() {
	default
	rm -R 3rdparty/{asio,expat,flac,glm,libjpeg,portaudio,portmidi,pugixml,rapidjson,utf8proc,zlib,zstd}/ || die
	rm docs/man/ldplayer.1  # so that we can glob-install later
}

src_compile() {
	args=(
		ARCH=  # to fix GENie compilation

		OSD=sdl3

		OVERRIDE_AR="$(tc-getAR)"
		OVERRIDE_CC="$(tc-getCC)"
		OVERRIDE_CXX="$(tc-getCXX)"
		OVERRIDE_LD="$(tc-getLD)"

		PYTHON_EXECUTABLE=python3

		TOOLS=1

		USE_SYSTEM_LIB_ASIO=1
		USE_SYSTEM_LIB_EXPAT=1
		USE_SYSTEM_LIB_FLAC=1
		USE_SYSTEM_LIB_GLM=1
		USE_SYSTEM_LIB_JPEG=1
		USE_SYSTEM_LIB_LUA=0  # to fix sol2 compilation
		USE_SYSTEM_LIB_PORTAUDIO=1
		USE_SYSTEM_LIB_PORTMIDI=1
		USE_SYSTEM_LIB_PUGIXML=1
		USE_SYSTEM_LIB_RAPIDJSON=1
		USE_SYSTEM_LIB_SQLITE3=0  # to fix mame compilation
		USE_SYSTEM_LIB_UTF8PROC=1
		USE_SYSTEM_LIB_ZLIB=1
		USE_SYSTEM_LIB_ZSTD=1

		VERBOSE=1
	)
	emake "${args[@]}"
}

src_install() {
	insinto /usr/share/games/mame/
	doins -r artwork/ bgfx/ ctrlr/ hash/ keymaps/ language/ plugins/ samples/

	insinto /usr/share/games/mame/fonts
	doins uismall.bdf

	doman docs/man/*.{1,6}

	dobin mame castool chdman floptool imgtool jedutil ldresample ldverify nltool nlwav romcmp unidasm
}
