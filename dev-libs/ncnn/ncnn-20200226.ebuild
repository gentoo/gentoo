# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A high-performance neural network inference framework"
HOMEPAGE="https://github.com/Tencent/ncnn"

SRC_URI="https://github.com/Tencent/ncnn/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="
	dev-util/glslang
	dev-util/vulkan-headers"

RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DCMAKE_TOOLCHAIN_FILE="${S}/toolchains/host.gcc.toolchain.cmake"
		-DNCNN_BUILD_EXAMPLES=OFF
		-DNCNN_BUILD_TOOLS=OFF
		-DNCNN_VULKAN=ON
	)

	cmake_src_configure
}
