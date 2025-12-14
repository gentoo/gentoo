# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=Vulkan-Headers
inherit cmake

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/vulkan-sdk-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
	S="${WORKDIR}"/${MY_PN}-vulkan-sdk-${PV}
fi

DESCRIPTION="Vulkan Header files and API registry"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Headers"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DVULKAN_HEADERS_ENABLE_MODULE=OFF
		-DVULKAN_HEADERS_ENABLE_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_install() {
	# VULKAN_HEADERS_ENABLE_MODULE doesn't seem to be working so just
	# delete the modules manually
	cmake_src_install
	find "${ED}" -name "*.cppm" -type f -delete || die
}
