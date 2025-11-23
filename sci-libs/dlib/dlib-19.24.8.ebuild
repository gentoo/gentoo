# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
inherit cmake cuda distutils-r1

DESCRIPTION="Numerical and networking C++ library"
HOMEPAGE="https://dlib.net/"
SRC_URI="https://github.com/davisking/dlib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cblas cuda debug examples ffmpeg gif jpeg lapack mkl png python sqlite test webp X cpu_flags_x86_avx cpu_flags_x86_sse2 cpu_flags_x86_sse4_1"
REQUIRED_USE="python? ( png ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

# doc needs a bunch of deps not in portage
RDEPEND="
	cblas? ( virtual/cblas )
	cuda? ( dev-libs/cudnn:= )
	ffmpeg? ( media-video/ffmpeg:=[X?] )
	gif? ( media-libs/giflib:= )
	jpeg? ( media-libs/libjpeg-turbo:0= )
	lapack? ( virtual/lapack )
	mkl? ( sci-libs/mkl )
	png? ( media-libs/libpng:0= )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( dev-db/sqlite:3 )
	webp? ( media-libs/libwebp:= )
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}"
BDEPEND="
	python? (
		${DISTUTILS_DEPS}
		test? (
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pip[${PYTHON_USEDEP}]
		)
	)
"

DOCS=( docs/README.txt )

PATCHES=(
	"${FILESDIR}/${P}"-disable-upstream-flags.patch
)

src_prepare() {
	use cuda && cuda_src_prepare
	cmake_src_prepare
	use python && distutils-r1_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDLIB_ENABLE_ASSERTS=$(usex debug)
		-DDLIB_ENABLE_STACK_TRACE=$(usex debug)
		-DDLIB_USE_FFMPEG=$(usex ffmpeg)
		-DDLIB_GIF_SUPPORT=$(usex gif)
		-DDLIB_JPEG_SUPPORT=$(usex jpeg)
		-DDLIB_PNG_SUPPORT=$(usex png)
		-DDLIB_LINK_WITH_SQLITE3=$(usex sqlite)
		-DDLIB_NO_GUI_SUPPORT=$(usex X OFF ON)
		-DDLIB_USE_BLAS=$(usex cblas)
		-DDLIB_USE_CUDA=$(usex cuda)
		-DDLIB_USE_LAPACK=$(usex lapack)
		-DDLIB_WEBP_SUPPORT=$(usex webp)
		-DUSE_AVX_INSTRUCTIONS=$(usex cpu_flags_x86_avx)
		-DUSE_SSE2_INSTRUCTIONS=$(usex cpu_flags_x86_sse2)
		-DUSE_SSE4_INSTRUCTIONS=$(usex cpu_flags_x86_sse4_1)
	)
	cmake_src_configure
	use python && distutils-r1_src_configure
}

src_compile() {
	cmake_src_compile
	use python && distutils-r1_src_compile
}

src_test() {
	(
		local BUILD_DIR="${BUILD_DIR}"/dlib/test
		mkdir -p "${BUILD_DIR}" || die
		cd "${BUILD_DIR}" >/dev/null || die

		local CMAKE_USE_DIR="${S}"/dlib/test
		cmake_src_configure
		cmake_build

		./dtest --runall || die "Tests failed"
	)

	use python && distutils-r1_src_test
}

python_test() {
	epytest
}

src_install() {
	cmake_src_install
	use python && distutils-r1_src_install

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}
	fi
}
