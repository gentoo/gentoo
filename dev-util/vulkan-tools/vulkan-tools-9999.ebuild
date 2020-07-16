# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=Vulkan-Tools
CMAKE_ECLASS="cmake"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit cmake-multilib python-any-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64"
	S="${WORKDIR}"/${MY_PN}-${PV}
fi

DESCRIPTION="Official Vulkan Tools and Utilities for Windows, Linux, Android, and MacOS"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Tools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="cube wayland +X"

# Cube demo only supports one window system at a time
REQUIRED_USE="!cube? ( || ( X wayland ) ) cube? ( ^^ ( X wayland ) )"

BDEPEND="${PYTHON_DEPS}
	>=dev-util/cmake-3.10.2
	cube? ( dev-util/glslang:=[${MULTILIB_USEDEP}] )
"
RDEPEND="
	>=media-libs/vulkan-loader-${PV}:=[${MULTILIB_USEDEP},wayland?,X?]
	wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11:=[${MULTILIB_USEDEP}]
		x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	>=dev-util/vulkan-headers-${PV}
"

pkg_setup() {
	MULTILIB_CHOST_TOOLS=(
		/usr/bin/vulkaninfo
	)

	use cube && MULTILIB_CHOST_TOOLS+=(
		/usr/bin/vkcube
		/usr/bin/vkcubepp
	)

	python-any-r1_pkg_setup
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_VULKANINFO=ON
		-DBUILD_CUBE=$(usex cube)
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
		-DVULKAN_HEADERS_INSTALL_DIR="${EPREFIX}/usr"
	)

	use cube && mycmakeargs+=(
		-DGLSLANG_INSTALL_DIR="${EPREFIX}/usr"
		-DCUBE_WSI_SELECTION=$(usex X XCB WAYLAND)
	)

	cmake_src_configure
}

multilib_src_install() {
	cmake_src_install
}
