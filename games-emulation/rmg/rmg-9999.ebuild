# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs xdg

MY_PN="${PN^^}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Rosalie's Mupen GUI"
HOMEPAGE="https://github.com/Rosalie241/RMG"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Rosalie241/${MY_PN}.git"
else
	SRC_URI="
		https://github.com//Rosalie241/${MY_PN}/archive/v${PV}/${MY_P}.tar.gz \
			-> ${P}.tar.gz
	"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64"
fi

LICENSE="
	BSD-2 CC0-1.0 GPL-2 GPL-3 MIT ZLIB public-domain
	angrylion-plugin? ( XMAME )
"
SLOT="0"
IUSE="angrylion-plugin dynarec netplay"

DEPEND="
	dev-libs/hidapi
	dev-libs/libusb:1
	dev-qt/qtbase:6[gui,opengl,vulkan,widgets]
	dev-qt/qtsvg:6
	media-libs/freetype
	media-libs/libpng:=
	media-libs/libsamplerate
	media-libs/libsdl3[opengl,vulkan]
	media-libs/speexdsp
	virtual/minizip:=
	virtual/opengl
	netplay? ( dev-qt/qtwebsockets:6 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	dynarec? ( dev-lang/nasm )
"

src_prepare() {
	# Remove unused 3rdParty code - https://bugs.gentoo.org/959468
	rm -r "${S}"/Source/3rdParty/imgui/examples || die
	rm -r "${S}"/Source/3rdParty/mupen64plus-rsp-parallel/win32 || die

	# Don't install XMAME licensed code
	if ! use angrylion-plugin; then
		rm -r "${S}"/Source/3rdParty/mupen64plus-video-angrylion-plus || die
	fi

	# Don't install pre-compiled binaries
	rm -r "${S}"/Source/3rdParty/vosk-api || die

	# Enable verbose make(1) output
	sed -e 's/CC=/V=1 CC=/' -i "${S}"/Source/3rdParty/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	export PKG_CONFIG="$(tc-getPKG_CONFIG)"

	local mycmakeargs=(
		-DAPPIMAGE_UPDATER=OFF
		-DNETPLAY=$(usex netplay)
		-DNO_ASM=$(usex dynarec OFF ON)
		-DPORTABLE_INSTALL=OFF
		-DUPDATER=OFF
		-DUSE_ANGRYLION=$(usex angrylion-plugin)
		-DUSE_CCACHE=OFF
		-DUSE_LTO=OFF
		-DVRU=OFF # Precompiled binaries
	)

	cmake_src_configure
}
