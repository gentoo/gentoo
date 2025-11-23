# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic toolchain-funcs

DESCRIPTION="High-performance neural network inference framework"
HOMEPAGE="https://github.com/Tencent/ncnn/"
SRC_URI="
	https://github.com/Tencent/ncnn/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD ZLIB"
SLOT="0/${PV}" # unstable ABI
KEYWORDS="amd64 ~x86"
IUSE="openmp tools +vulkan"

# Need the static library to run tests + skip vulkan / GPU:
# -DNCNN_BUILD_TESTS=ON -DNCNN_SHARED_LIB=OFF -DNCNN_VULKAN=OFF
RESTRICT="test"

# dlopen: vulkan-loader
RDEPEND="
	tools? (
		dev-cpp/abseil-cpp:=
		dev-libs/protobuf:=
	)
	vulkan? (
		dev-util/glslang:=
		dev-util/spirv-tools
		media-libs/vulkan-loader
	)
"
DEPEND="
	${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="
	tools? ( dev-libs/protobuf[protoc(+)] )
"

DOCS=( README.md docs/. )

PATCHES=(
	"${FILESDIR}"/${PN}-20241226-avx512.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	filter-lto # -Werror=odr issues

	local mycmakeargs=(
		-DGLSLANG_TARGET_DIR="${ESYSROOT}"/usr/$(get_libdir)/cmake
		-DNCNN_BUILD_EXAMPLES=no
		-DNCNN_BUILD_TOOLS=$(usex tools)
		-DNCNN_OPENMP=$(usex openmp)
		-DNCNN_PYTHON=no # todo only if something needs it
		-DNCNN_SHARED_LIB=yes
		-DNCNN_SIMPLEVK=no
		-DNCNN_SYSTEM_GLSLANG=yes
		-DNCNN_VERSION=${PV} # avoids libncnn.so.*.%Y%m%d using build date
		-DNCNN_VULKAN=$(usex vulkan)
	)

	# temporary workaround due to a >=clang-18 regression (bug #929228)
	tc-is-clang && [[ $(clang-major-version) -ge 18 ]] &&
		mycmakeargs+=( -DNCNN_AVX512BF16=no )

	cmake_src_configure
}
