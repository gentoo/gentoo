# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PV="${PV/_/-}"

inherit cmake multilib wxwidgets

DESCRIPTION="A PlayStation 2 emulator"
HOMEPAGE="https://www.pcsx2.net"
SRC_URI="https://github.com/PCSX2/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	app-arch/bzip2[abi_x86_32(-)]
	app-arch/xz-utils[abi_x86_32(-)]
	dev-libs/libaio[abi_x86_32(-)]
	media-libs/alsa-lib[abi_x86_32(-)]
	media-libs/libpng:=[abi_x86_32(-)]
	media-libs/libsdl[abi_x86_32(-),joystick,sound]
	media-libs/libsoundtouch[abi_x86_32(-)]
	media-libs/portaudio[abi_x86_32(-)]
	sys-libs/zlib[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/gtk+:2[abi_x86_32(-)]
	x11-libs/libICE[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/wxGTK:3.0[abi_x86_32(-),X]
"
DEPEND="${RDEPEND}
	dev-cpp/pngpp
	dev-cpp/sparsehash
"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc5.patch
	"${FILESDIR}"/${P}-xgetbv.patch
)

src_configure() {
	multilib_toolchain_setup x86

	# pcsx2 build scripts will force CMAKE_BUILD_TYPE=Devel
	# if it something other than "Devel|Debug|Release"
	local CMAKE_BUILD_TYPE="Release"

	if use amd64; then
		# Passing correct CMAKE_TOOLCHAIN_FILE for amd64
		# https://github.com/PCSX2/pcsx2/pull/422
		local MYCMAKEARGS=(-DCMAKE_TOOLCHAIN_FILE=cmake/linux-compiler-i386-multilib.cmake)
	fi

	local mycmakeargs=(
		-DARCH_FLAG=
		-DDISABLE_BUILD_DATE=TRUE
		-DDISABLE_PCSX2_WRAPPER=TRUE
		-DEXTRA_PLUGINS=FALSE
		-DOPTIMIZATION_FLAG=
		-DPACKAGE_MODE=TRUE
		-DXDG_STD=TRUE

		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_LIBRARY_PATH="/usr/$(get_libdir)/${PN}"
		-DDOC_DIR=/usr/share/doc/"${PF}"
		-DEGL_API=FALSE
		-DGTK3_API=FALSE
		-DPLUGIN_DIR="/usr/$(get_libdir)/${PN}"
		# wxGTK must be built against same sdl version
		-DSDL2_API=FALSE
		-DWX28_API=FALSE
	)

	WX_GTK_VER="3.0" setup-wxwidgets
	cmake_src_configure
}

src_install() {
	# Upstream issue: https://github.com/PCSX2/pcsx2/issues/417
	QA_TEXTRELS="usr/$(get_libdir)/pcsx2/* usr/bin/PCSX2"
	cmake_src_install
}
