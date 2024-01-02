# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="High-performance neural network inference framework"
HOMEPAGE="https://github.com/Tencent/ncnn/"
SRC_URI="
	https://github.com/Tencent/ncnn/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD ZLIB"
SLOT="0/${PV}" # currently has unstable ABI that often requires rebuilds
KEYWORDS="~amd64 ~x86"
IUSE="tools +vulkan"

# Need the static library to run tests + skip vulkan / GPU:
# -DNCNN_BUILD_TESTS=ON -DNCNN_SHARED_LIB=OFF -DNCNN_VULKAN=OFF
RESTRICT="test"

RDEPEND="
	tools? (
		dev-cpp/abseil-cpp:=
		dev-libs/protobuf:=
	)
	vulkan? (
		dev-util/glslang:=
		media-libs/vulkan-loader
	)
"
DEPEND="
	${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"

DOCS=( README.md docs/. )

src_configure() {
	local mycmakeargs=(
		-DGLSLANG_TARGET_DIR="${ESYSROOT}"/usr/$(get_libdir)/cmake
		-DNCNN_BUILD_EXAMPLES=no
		-DNCNN_BUILD_TOOLS=$(usex tools)
		-DNCNN_PYTHON=no # todo if something needs it
		-DNCNN_SHARED_LIB=yes
		-DNCNN_SIMPLEVK=no
		-DNCNN_SYSTEM_GLSLANG=yes
		-DNCNN_VERSION=${PV} # avoids libncnn.so.*.%Y%m%d using build date
		-DNCNN_VULKAN=$(usex vulkan)
	)

	cmake_src_configure
}
