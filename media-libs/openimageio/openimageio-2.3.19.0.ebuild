# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FONT_PN=OpenImageIO
PYTHON_COMPAT=( python3_{8..10} )

TEST_OIIO_IMAGE_COMMIT="b85d7a3a10a3256b50325ad310c33e7f7cf2c6cb"
TEST_OEXR_IMAGE_COMMIT="f17e353fbfcde3406fe02675f4d92aeae422a560"
inherit cmake font python-single-r1

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="https://sites.google.com/site/openimageio/ https://github.com/OpenImageIO"
SRC_URI="https://github.com/OpenImageIO/oiio/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" test? (
		https://github.com/OpenImageIO/oiio-images/archive/${TEST_OIIO_IMAGE_COMMIT}.tar.gz -> ${PN}-oiio-test-image-${TEST_OIIO_IMAGE_COMMIT}.tar.gz
		https://github.com/AcademySoftwareFoundation/openexr-images/archive/${TEST_OEXR_IMAGE_COMMIT}.tar.gz -> ${PN}-oexr-test-image-${TEST_OEXR_IMAGE_COMMIT}.tar.gz
	)"
S="${WORKDIR}/oiio-${PV}"

LICENSE="BSD"
# TODO: drop .1 on next SONAME change (2.3 -> 2.4?) as we needed to nudge it
# for changing to openexr 3 which broke ABI.
SLOT="0/$(ver_cut 1-2).1"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

X86_CPU_FEATURES=(
	aes:aes sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="dicom doc ffmpeg gif jpeg2k opencv opengl openvdb ptex python qt5 raw test +truetype ${CPU_FEATURES[@]%:*}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Not quite working yet
RESTRICT="!test? ( test ) test"

BDEPEND="
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
"
RDEPEND="
	dev-libs/boost:=
	dev-cpp/robin-map
	dev-libs/libfmt:=
	dev-libs/pugixml:=
	>=media-libs/libheif-1.7.0:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	>=media-libs/libwebp-0.2.1:=
	>=dev-libs/imath-3.1.2-r4:=
	>=media-libs/opencolorio-2.1.1-r4:=
	>=media-libs/openexr-3:0=
	media-libs/tiff:0=
	sys-libs/zlib:=
	dicom? ( sci-libs/dcmtk )
	ffmpeg? ( media-video/ffmpeg:= )
	gif? ( media-libs/giflib:0= )
	jpeg2k? ( >=media-libs/openjpeg-2.0:2= )
	opencv? ( media-libs/opencv:= )
	opengl? (
		media-libs/glew:=
		virtual/glu
		virtual/opengl
	)
	openvdb? (
		dev-cpp/tbb:=
		media-gfx/openvdb:=
	)
	ptex? ( media-libs/ptex:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost:=[python,${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pybind11[${PYTHON_USEDEP}]
		')
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		opengl? ( dev-qt/qtopengl:5 )
	)
	raw? ( media-libs/libraw:= )
	truetype? ( media-libs/freetype:2= )
"
DEPEND="${RDEPEND}"

DOCS=( CHANGES.md CREDITS.md README.md )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	cmake_comment_add_subdirectory src/fonts

	if use test ; then
		mkdir -p "${BUILD_DIR}"/testsuite || die
		mv "${WORKDIR}"/oiio-images-${TEST_OIIO_IMAGE_COMMIT} "${BUILD_DIR}"/testsuite/oiio-images || die
		mv "${WORKDIR}"/openexr-images-${TEST_OEXR_IMAGE_COMMIT} "${BUILD_DIR}"/testsuite/openexr-images || die
	fi
}

src_configure() {
	# Build with SIMD support
	local cpufeature
	local mysimd=()
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
	done

	# If no CPU SIMDs were used, completely disable them
	[[ -z ${mysimd} ]] && mysimd=("0")

	local mycmakeargs=(
		-DVERBOSE=ON
		-DBUILD_TESTING=$(usex test)
		-DOIIO_BUILD_TESTS=$(usex test)
		-DINSTALL_FONTS=OFF
		-DBUILD_DOCS=$(usex doc)
		-DINSTALL_DOCS=$(usex doc)
		-DSTOP_ON_WARNING=OFF
		-DUSE_CCACHE=OFF
		-DUSE_DCMTK=$(usex dicom)
		-DUSE_EXTERNAL_PUGIXML=ON
		-DUSE_JPEGTURBO=ON
		-DUSE_NUKE=OFF # not in Gentoo
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_GIF=$(usex gif)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENGL=$(usex opengl)
		-DUSE_OPENVDB=$(usex openvdb)
		-DUSE_PTEX=$(usex ptex)
		-DUSE_PYTHON=$(usex python)
		-DUSE_QT=$(usex qt5)
		-DUSE_LIBRAW=$(usex raw)
		-DUSE_FREETYPE=$(usex truetype)
		-DUSE_SIMD=$(local IFS=','; echo "${mysimd[*]}")
	)
	if use python; then
		mycmakeargs+=(
			-DPYTHON_VERSION=${EPYTHON#python}
			-DPYTHON_SITE_DIR=$(python_get_sitedir)
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	# can't use font_src_install
	# it does directory hierarchy recreation
	FONT_S=(
		"${S}/src/fonts/Droid_Sans"
		"${S}/src/fonts/Droid_Sans_Mono"
		"${S}/src/fonts/Droid_Serif"
	)
	insinto ${FONTDIR}
	for dir in "${FONT_S[@]}"; do
		doins "${dir}"/*.ttf
	done
}
