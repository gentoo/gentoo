# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
inherit cmake cuda distutils-r1

DESCRIPTION="Numerical and networking C++ library"
HOMEPAGE="https://dlib.net/"
SRC_URI="
	https://github.com/davisking/dlib/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/davisking/dlib/commit/e529d2a1f11ff9dac86251e21a0c90d4a58721e0.patch
		-> ${P}-docs-c++14.patch
	https://github.com/davisking/dlib/commit/a078e810f7e653daa4172b2ed19d8f0e22e26b6f.patch
		-> ${P}-pessimizing-move.patch
	https://github.com/davisking/dlib/commit/79e2d1373add8d9e265d6a16c4952f5273600e97.patch
		-> ${P}-fix-YOLO-loss-gradient.patch
	https://github.com/davisking/dlib/commit/d0f41798be7a64cb15f94611d960475cf3097b0c.patch
		-> ${P}-matlab-ut-library.patch
	https://github.com/davisking/dlib/commit/3cb1f350021b5d64771d05678672e887000062ce.patch
		-> ${P}-large-image-load.patch
	https://github.com/davisking/dlib/commit/131e46e4c5fb75a89a3c6ad89f6dccc7ed38473c.patch
		-> ${P}-throw-noexcept.patch
	https://github.com/davisking/dlib/commit/043bed89bd5e922446b0705e5c42ece51940b075.patch
		-> ${P}-python-3.14-numpy-fix.patch
	https://github.com/davisking/dlib/commit/e93a0ef1d81b3747b84d89f65bdd52974cac71b9.patch
		-> ${P}-c++23-update.patch
	https://github.com/davisking/dlib/commit/56b806d1d389ea016c845a4da546ab082c4ff7a0.patch
		-> ${P}-regular-tools.patch
	https://github.com/davisking/dlib/commit/4cf8f5759fe715b0defb0ba998ac1c354b814cca.patch
		-> ${P}-newer-python-tools.patch
	https://github.com/davisking/dlib/commit/fb0865ba8c7f04ee1f8fea3fe3d04870bda3ea08.patch
		-> ${P}-Wcast-user-defined.patch
	https://github.com/davisking/dlib/commit/0d2153abd0da7f9bba8104ba8c732a985d821461.patch
		-> ${P}-enable-FFMpeg-7.1-API.patch
	https://github.com/davisking/dlib/commit/ffe78814638d100cbd12e116990afb1903b82b5e.patch
		-> ${P}-unicode.patch
	https://github.com/davisking/dlib/commit/5ce4891406d32d8b49ee44253bd1bd1f1ca34c54.patch
		-> ${P}-FindCUDAToolkit.patch
	https://github.com/davisking/dlib/commit/35a8e1fa3fa1bd1689119f437bd2e3a27d548332.patch
		-> ${P}-test_loss_multibinary_log.patch
	"

LICENSE="Boost-1.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
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
	# Do not treat warnings as errors
	"${FILESDIR}/${PN}-19.24.8-disable-upstream-flags.patch"

	# Docs: dlib requires c++14 (#3079)
	"${DISTDIR}/${P}-docs-c++14.patch"

	# Remove std::move where clang warns of pessimizing-
	# move (#3080)
	"${DISTDIR}/${P}-pessimizing-move.patch"

	# Fix: Correct YOLO loss gradient for x,y coordinates (#3088)
	"${DISTDIR}/${P}-fix-YOLO-loss-gradient.patch"

	# Fix the miss of including matlab ut library (#3089)
	"${DISTDIR}/${P}-matlab-ut-library.patch"

	# Fix large images (40792x20480 RGBA PNG for ex.)
	# read (#3091)
	"${DISTDIR}/${P}-large-image-load.patch"

	# throw() -> noexcept (#3092)
	"${DISTDIR}/${P}-throw-noexcept.patch"

	# Account for change in ref count in Python 3.14+ (#3098)
	"${DISTDIR}/${P}-python-3.14-numpy-fix.patch"

	# std::aligned_storage_t is deprecated in c++23 (#3100)
	"${DISTDIR}/${P}-c++23-update.patch"

	# Fix up build errors with the regular makefile
	# and non-cmake builds
	"${DISTDIR}/${P}-regular-tools.patch"

	# Update python packaging to work with newer
	# toolchains (#3102)
	"${DISTDIR}/${P}-newer-python-tools.patch"

	# Fix -Wcast-user-defined (#3103)
	"${DISTDIR}/${P}-Wcast-user-defined.patch"

	# FFMpeg 7.1 API (#3105)
	"${DISTDIR}/${P}-enable-FFMpeg-7.1-API.patch"

	# Fixed warning in convert_mbstring_to_wstring() (#3110)
	"${DISTDIR}/${P}-unicode.patch"

	# Replace FindCUDA with FindCUDAToolkit (fix #2833) (#3090)
	"${DISTDIR}/${P}-FindCUDAToolkit.patch"

	# Improve the somewhat flaky test_loss_multibinary_log
	# by avoiding samples very close to class boundaries (#3112)
	"${DISTDIR}/${P}-test_loss_multibinary_log.patch"
)

src_prepare() {

	# CUDA
	use cuda && cuda_src_prepare

	# CMake
	cmake_src_prepare

	# Python
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
