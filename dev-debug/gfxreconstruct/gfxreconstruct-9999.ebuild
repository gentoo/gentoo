# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit cmake

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/LunarG/gfxreconstruct.git"
	EGIT_SUBMODULES=( external/{Vulkan-Headers,SPIRV-Headers,SPIRV-Reflect} )
	inherit git-r3
else
	SRC_URI="
		https://github.com/LunarG/${PN}/archive/vulkan-sdk-${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/KhronosGroup/SPIRV-Reflect/archive/vulkan-sdk-${PV}.tar.gz -> SPIRV-Reflect-${PV}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}"/${PN}-vulkan-sdk-${PV}
fi

DESCRIPTION="Graphics API Capture and Replay Tools"
HOMEPAGE="https://github.com/LunarG/gfxreconstruct"

LICENSE="MIT"
SLOT="0"
IUSE="wayland X"

RDEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
	sys-libs/zlib:=

	media-libs/vulkan-loader[wayland?,X?]
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
"
DEPEND="${RDEPEND}
	X? ( x11-libs/libXrandr )
"
if [[ ${PV} == 9999* ]]; then
	DEPEND+="
		~dev-util/spirv-headers-${PV}
		~dev-util/vulkan-headers-${PV}
	"
else
	PATCHES=(
		"${FILESDIR}"/1.3.296.0-use-system-vulkan.patch
	)
fi

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
	else
		default
		rmdir "${S}"/external/SPIRV-Reflect || die
		mv "${WORKDIR}"/SPIRV-Reflect-vulkan-sdk-${PV} "${S}"/external/SPIRV-Reflect || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_WERROR=OFF
		-DBUILD_WSI_DISPLAY_SUPPORT=ON
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
	)
	cmake_src_configure
}
