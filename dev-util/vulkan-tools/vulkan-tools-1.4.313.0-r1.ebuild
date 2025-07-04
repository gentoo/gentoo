# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=Vulkan-Tools
PYTHON_COMPAT=( python3_{11..14} )
inherit cmake-multilib python-any-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/vulkan-sdk-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv"
	S="${WORKDIR}"/${MY_PN}-vulkan-sdk-${PV}
fi

DESCRIPTION="Official Vulkan Tools and Utilities for Windows, Linux, Android, and MacOS"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Tools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="cube wayland test X"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	cube? ( ~dev-util/glslang-${PV}:=[${MULTILIB_USEDEP}] )
"
RDEPEND="
	wayland? ( dev-libs/wayland[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libxcb:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	~dev-util/vulkan-headers-${PV}
	X? ( x11-libs/libXrandr[${MULTILIB_USEDEP}] )
	test? ( ~media-libs/vulkan-loader-${PV}[${MULTILIB_USEDEP},wayland?,X?] )
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
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG -DGIT_BRANCH_NAME=\\\"gentoo\\\" -DGIT_TAG_INFO=\\\"${PV//./_}\\\""
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_VULKANINFO=ON
		-DBUILD_CUBE=$(usex cube)
		-DBUILD_TESTS=$(usex test)
		-DBUILD_WERROR=OFF
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
		-DVULKAN_HEADERS_INSTALL_DIR="${ESYSROOT}/usr"
	)

	cmake_src_configure
}

pkg_postinst() {
	if use cube; then
		einfo "As of version 1.4.304.0, the window system for 'vkcube' and 'vkcubepp'"
		einfo "can be selected at runtime using the '--wsi' runtime argument."
		einfo "For example, Wayland can be selected using '--wsi wayland'."
		einfo "As such, 'vkcube-wayland' has been removed and the runtime argument"
		einfo "must be used instead. See 'vkcube --help' for more information."
	fi
}
