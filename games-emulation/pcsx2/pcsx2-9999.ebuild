# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit cmake fcaps flag-o-matic git-r3 toolchain-funcs wxwidgets

DESCRIPTION="A PlayStation 2 emulator"
HOMEPAGE="https://pcsx2.net/"
EGIT_REPO_URI="https://github.com/PCSX2/${PN}.git"
EGIT_SUBMODULES=(
	3rdparty/glslang/glslang # needs StandAlone/ResourceLimits.h
	3rdparty/imgui/imgui # not made to be system-wide
	3rdparty/vulkan-headers # to keep in sync with glslang
)

LICENSE="GPL-3 Apache-2.0 OFL-1.1" # TODO: needs review for a full list
SLOT="0"
KEYWORDS=""
IUSE="pulseaudio test"

RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/xz-utils
	app-arch/zstd:=
	dev-cpp/rapidyaml:=
	dev-libs/glib:2
	dev-libs/libaio
	dev-libs/libchdr
	>=dev-libs/libfmt-7.1.3:=
	dev-libs/libxml2:2
	dev-libs/libzip:=[zstd]
	media-libs/alsa-lib
	media-libs/cubeb
	media-libs/freetype
	media-libs/libglvnd
	media-libs/libpng:=
	media-libs/libsamplerate
	media-libs/libsdl2[haptic,joystick,sound]
	media-libs/libsoundtouch:=
	net-libs/libpcap
	sys-libs/zlib
	virtual/libudev:=
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libICE
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="test? ( dev-cpp/gtest )"

FILECAPS=(
	-m 755 "CAP_NET_RAW+eip CAP_NET_ADMIN+eip" usr/bin/pcsx2
)

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0-crcs.patch
)

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary && $(tc-getCC) == *gcc* ]]; then
		# -mxsave flag is needed when GCC >= 8.2 is used
		# https://bugs.gentoo.org/685156
		append-flags -mxsave
	fi
}

src_prepare() {
	cmake_src_prepare

	# unbundle, use sed over patch for less chances to break -9999
	# note: gentoo's zstd lacks a cmake module which upstream tries to use
	sed -e '/add_subdir.*cubeb/c\find_package(cubeb REQUIRED)' \
		-e '/add_subdir.*libchdr/c\pkg_check_modules(chdr REQUIRED IMPORTED_TARGET libchdr)\nalias_library(chdr-static PkgConfig::chdr)' \
		-e '/system_library.*zstd/,/endif()/c\pkg_check_modules(zstd REQUIRED IMPORTED_TARGET libzstd)\nalias_library(Zstd::Zstd PkgConfig::zstd)' \
		-e '/compile_options(\(cubeb\|chdr-static\|speex\)/d' \
		-i cmake/SearchForStuff.cmake || die

	# pulseaudio is only used for usb-mic, not audio output
	use pulseaudio || > cmake/FindPulseAudio.cmake || die
}

src_configure() {
	# Build with ld.gold fails
	# https://github.com/PCSX2/pcsx2/issues/1671
	tc-ld-disable-gold

	# pcsx2 build scripts will force CMAKE_BUILD_TYPE=Devel
	# if it something other than "Devel|Debug|Release"
	local CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=FALSE
		-DDISABLE_ADVANCE_SIMD=TRUE
		-DDISABLE_BUILD_DATE=TRUE
		-DDISABLE_PCSX2_WRAPPER=TRUE
		-DDISABLE_SETCAP=TRUE
		-DENABLE_TESTS=$(usex test)
		-DPACKAGE_MODE=TRUE
		-DQT_BUILD=FALSE # TODO when qt6 is in tree
		-DSDL2_API=TRUE # conditionally needed if wxGTK[sdl], cmake/ApiValidation.cmake
		-DUSE_SYSTEM_LIBS=TRUE
		-DUSE_VTUNE=FALSE
		-DXDG_STD=TRUE
	)

	setup-wxwidgets
	cmake_src_configure
}
