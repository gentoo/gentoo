# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/beetle-psx-libretro"
LIBRETRO_COMMIT_SHA="9e0e95bc2b5f51c467e91defcbb09d7602ce4bc6"

inherit libretro-core

DESCRIPTION="Standalone port/fork of Mednafen PSX to the Libretro API"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl vulkan"

RDEPEND="
	dev-libs/libbsd
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libxcb

	opengl? ( virtual/opengl )
	vulkan? ( media-libs/vulkan-loader )
"
DEPEND="${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"

src_compile() {
	local myemakeargs=(
		$(usex opengl "HAVE_OPENGL=1" "")
		$(usex vulkan "HAVE_VULKAN=1" "")
	)
	libretro-core_src_compile
}

src_install() {
	LIBRETRO_CORE_LIB_FILE="${S}/mednafen_psx_hw_libretro.so" \
		libretro-core_src_install
}
