# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/Vulkan-ValidationLayers.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	EGIT_COMMIT="89bbac497742d48c3d483f78b1bba99101784746"
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Vulkan-ValidationLayers-${EGIT_COMMIT}"
fi

inherit python-any-r1 cmake-multilib

DESCRIPTION="Vulkan Validation Layers"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-ValidationLayers"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="X wayland"

# Old packaging will cause file collisions
RDEPEND="!<=media-libs/vulkan-loader-1.1.70.0-r999"
DEPEND="${PYTHON_DEPS}
		>=dev-util/glslang-7.9.2888:=[${MULTILIB_USEDEP}]
		>=dev-util/spirv-tools-2018.2-r1:=[${MULTILIB_USEDEP}]
		>=dev-util/vulkan-headers-1.1.82.0
		wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
		X? (
		   x11-libs/libX11:=[${MULTILIB_USEDEP}]
		   x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
		   )"

PATCHES=(
	"${FILESDIR}/${PN}-Use-a-file-to-get-the-spirv-tools-commit-ID.patch"
	 )

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=True
		-DBUILD_WSI_MIR_SUPPORT=False
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
		-DBUILD_TESTS=False
		-DGLSLANG_INSTALL_DIR="/usr"
		-DVULKAN_HEADERS_INSTALL_DIR="/usr"
	)
	cmake-utils_src_configure
}
