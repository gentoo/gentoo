# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_{4,5} )

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers/archive/sdk-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Vulkan-LoaderAndValidationLayers-sdk-${PV}"
fi

inherit python-any-r1 cmake-multilib

DESCRIPTION="Vulkan Installable Client Driver (ICD) Loader"
HOMEPAGE="https://www.khronos.org/vulkan/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND=""

DOCS=( README.md LICENSE.txt )

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=True
		-DBUILD_TESTS=False
		-DBUILD_LAYERS=False
		-DBUILD_DEMOS=False
		-DBUILD_VKJSON=False
		-DBUILD_LOADER=True
		-DBUILD_WSI_MIR_SUPPORT=False
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	keepdir /etc/vulkan/icd.d

	cd "${BUILD_DIR}/loader"
	dolib libvulkan.so.1.*
	dosym libvulkan.so.1.* /usr/$(get_libdir)/libvulkan.so.1
	dosym libvulkan.so.1.* /usr/$(get_libdir)/libvulkan.so

	cd "${S}"
	insinto /usr/include/vulkan
	doins include/vulkan/*.h
	einstalldocs
}
