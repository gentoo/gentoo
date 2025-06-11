# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1

CRATES="
	cc@1.0.83
	cfg-if@1.0.0
	libc@0.2.152
	libloading@0.7.4
	libusb1-sys@0.6.4
	once_cell@1.19.0
	pkg-config@0.3.29
	proc-macro2@1.0.78
	quote@1.0.35
	rusb@0.9.3
	serde@1.0.195
	serde_derive@1.0.195
	syn@2.0.48
	toml@0.5.11
	unicode-ident@1.0.12
	vcpkg@0.2.15
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
"

inherit cargo cmake toolchain-funcs xdg

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
		rust-plugin? ( ${CARGO_CRATE_URIS} )
	"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64"
fi

LICENSE="
	BSD-2 CC0-1.0 GPL-2 GPL-3 MIT ZLIB public-domain
	angrylion-plugin? ( XMAME )
	rust-plugin? ( ISC Unicode-DFS-2016 )
"
SLOT="0"
IUSE="angrylion-plugin discord dynarec netplay rust-plugin"

DEPEND="
	dev-libs/hidapi
	dev-qt/qtbase:6[gui,opengl,vulkan,widgets]
	dev-qt/qtsvg:6
	media-libs/freetype
	media-libs/libpng:=
	media-libs/libsamplerate
	media-libs/libsdl2[haptic,joystick,opengl,sound,vulkan]
	media-libs/speexdsp
	sys-libs/zlib[minizip(+)]
	virtual/opengl
	netplay? (
		dev-qt/qtwebsockets:6
		media-libs/sdl2-net
	)
	rust-plugin? ( dev-libs/libusb:1 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	dynarec? ( dev-lang/nasm )
	rust-plugin? ( ${RUST_DEPEND} )
"

pkg_setup() {
	QA_FLAGS_IGNORED="/usr/$(get_libdir)/RMG/Plugin/Input/libmupen64plus_input_gca.so"
	use rust-plugin && rust_pkg_setup
}

src_unpack() {
	if [[ "${PV}" == *9999 ]] ; then
		git-r3_src_unpack
		if use rust-plugin; then
			S="${S}"/Source/3rdParty/mupen64plus-input-gca \
			cargo_live_src_unpack
		fi
	else
		if use rust-plugin; then
			cargo_src_unpack
		else
			default
		fi
	fi
}

src_prepare() {
	cmake_src_prepare

	# Don't install unused 3rdParty code
	rm -r "${S}"/Source/3rdParty/fmt || die

	# Don't install XMAME licensed code
	if ! use angrylion-plugin; then
		rm -r "${S}"/Source/3rdParty/mupen64plus-video-angrylion-plus || die
	fi

	# Don't install pre-compiled binaries
	rm -r "${S}"/Source/3rdParty/vosk-api || die

	# Enable verbose make(1) output
	sed -e 's/CC=/V=1 CC=/' -i "${S}"/Source/3rdParty/CMakeLists.txt || die
}

src_configure() {
	export PKG_CONFIG="$(tc-getPKG_CONFIG)"
	export PKG_CONFIG_ALLOW_CROSS=1

	local mycmakeargs=(
		-DAPPIMAGE_UPDATER=OFF
		-DDISCORD_RPC=$(usex discord)
		-DNETPLAY=$(usex netplay)
		-DNO_ASM=$(usex dynarec OFF ON)
		-DNO_RUST=$(usex rust-plugin OFF ON)
		-DPORTABLE_INSTALL=OFF
		-DUPDATER=OFF
		-DUSE_ANGRYLION=$(usex angrylion-plugin)
		-DUSE_CCACHE=OFF
		-DUSE_LIBFMT=OFF # Use std::format
		-DUSE_LTO=OFF
		-DVRU=OFF # Precompiled binaries
	)

	cmake_src_configure
}
