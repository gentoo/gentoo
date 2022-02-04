# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="High-performance neural network inference framework"
HOMEPAGE="https://github.com/Tencent/ncnn"
SRC_URI="https://github.com/Tencent/ncnn/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tools +vulkan"

# Need the static library to run tests:
# -DNCNN_BUILD_TESTS=ON, -DNCNN_SHARED_LIB=OFF, USE=-vulkan (skip GPU)
RESTRICT="test"

RDEPEND="
	dev-util/glslang
	tools? ( dev-libs/protobuf:= )
	vulkan? ( media-libs/vulkan-loader )"
DEPEND="
	${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )"

PATCHES=(
	"${FILESDIR}"/${PN}-fix-glslang-include.patch
)
DOCS=( README.md docs/. )

src_prepare() {
	cmake_src_prepare

	sed -i "/DESTINATION/s| lib| $(get_libdir)|" src/CMakeLists.txt || die

	# Workaround build issues on AVX without AVX2 (bug #730468)
	# This can be removed if CXXFLAGS="-mavx -mno-avx2" builds after a bump.
	find src -type f -exec sed -i s/__AVX__/__AVX2__/g {} + || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON # for tools
		-DGLSLANG_TARGET_DIR="${ESYSROOT}"/usr/$(get_libdir)/cmake
		-DNCNN_BUILD_EXAMPLES=OFF
		-DNCNN_BUILD_TOOLS=$(usex tools)
		-DNCNN_PYTHON=OFF # missing portalocker, and nothing needs this for now
		-DNCNN_SHARED_LIB=ON
		-DNCNN_SYSTEM_GLSLANG=ON
		-DNCNN_VERSION=${PV} # avoids libncnn.so.*.%Y%m%d (build date)
		-DNCNN_VULKAN=$(usex vulkan)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use tools; then
		local tools=(
			caffe/caffe2ncnn
			darknet/darknet2ncnn
			mxnet/mxnet2ncnn
			ncnn2mem
			ncnnmerge
			ncnnoptimize
			onnx/onnx2ncnn
			quantize/{ncnn2int8,ncnn2table}
		)
		dobin "${tools[@]/#/${BUILD_DIR}/tools/}"
	fi
}
