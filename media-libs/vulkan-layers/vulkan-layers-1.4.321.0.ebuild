# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=Vulkan-ValidationLayers
PYTHON_COMPAT=( python3_{11..14} )
inherit cmake-multilib python-any-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/vulkan-sdk-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}"/${MY_PN}-vulkan-sdk-${PV}
fi

DESCRIPTION="Vulkan Validation Layers"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-ValidationLayers"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="wayland test X"
# Many segfaults as of 1.4.313.0
RESTRICT="!test? ( test ) test"

RDEPEND="~dev-util/spirv-tools-${PV}[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	~dev-util/glslang-${PV}:=[${MULTILIB_USEDEP}]
	~dev-util/spirv-headers-${PV}
	~dev-util/vulkan-headers-${PV}
	~dev-util/vulkan-utility-libraries-${PV}:=[${MULTILIB_USEDEP}]
	wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11:=[${MULTILIB_USEDEP}]
		x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	)
"

QA_SONAME="/usr/lib[^/]*/libVkLayer_khronos_validation.so"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.313.0-tests-no-static.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_WERROR=OFF
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

multilib_src_install_all() {
	find "${ED}" -type f -name \*.a -delete || die
}
