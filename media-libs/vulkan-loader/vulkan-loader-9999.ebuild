# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/Vulkan-Loader.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/KhronosGroup/Vulkan-Loader/archive/sdk-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Vulkan-Loader-sdk-${PV}"
fi

inherit python-any-r1 cmake-multilib

DESCRIPTION="Vulkan Installable Client Driver (ICD) Loader"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="layers wayland X"

RDEPEND=""
DEPEND="${PYTHON_DEPS}
	dev-util/vulkan-headers
	layers? ( media-libs/vulkan-layers:=[${MULTILIB_USEDEP}] )
	wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11:=[${MULTILIB_USEDEP}]
		x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/${P}-Do-not-install-vulkan-headers.patch"
	"${FILESDIR}/${P}-Use-usr-for-vulkan-headers.patch"
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=True
		-DBUILD_TESTS=False
		-DBUILD_LOADER=True
		-DBUILD_WSI_MIR_SUPPORT=False
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	keepdir /etc/vulkan/icd.d

	cmake-utils_src_install
}

pkg_postinst() {
	einfo "USE=demos has been dropped as per upstream packaging"
	einfo "vulkaninfo is now available in the media-libs/vulkan-tools package"
}
