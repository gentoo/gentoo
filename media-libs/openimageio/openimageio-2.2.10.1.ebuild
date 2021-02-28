# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_PN=OpenImageIO
PYTHON_COMPAT=( python3_{7..9} )
inherit cmake font python-single-r1

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="https://sites.google.com/site/openimageio/ https://github.com/OpenImageIO"
SRC_URI="https://github.com/OpenImageIO/oiio/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/oiio-Release-${PV}"

LICENSE="BSD"
SLOT="0/2.2"
KEYWORDS="~amd64 ~arm64 ~ppc64 x86"

X86_CPU_FEATURES=(
	aes:aes sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="dicom doc ffmpeg field3d gif jpeg2k opencv opengl openvdb ptex python qt5 raw +truetype ${CPU_FEATURES[@]%:*}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# test data in separate repo
# second repo has no structure whatsoever
RESTRICT="test"

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
	>=dev-libs/boost-1.62:=
	dev-cpp/robin-map
	dev-libs/libfmt:=
	dev-libs/pugixml:=
	>=media-libs/ilmbase-2.2.0-r1:=
	>=media-libs/libheif-1.7.0:=
	media-libs/libpng:0=
	>=media-libs/libwebp-0.2.1:=
	media-libs/opencolorio:=
	>=media-libs/openexr-2.2.0-r2:=
	media-libs/tiff:0=
	sys-libs/zlib:=
	virtual/jpeg:0
	dicom? ( sci-libs/dcmtk )
	ffmpeg? ( media-video/ffmpeg:= )
	field3d? ( media-libs/Field3D:= )
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
		-DOIIO_BUILD_TESTS=OFF
		-DINSTALL_FONTS=OFF
		-DBUILD_DOCS=$(usex doc)
		-DINSTALL_DOCS=$(usex doc)
		-DSTOP_ON_WARNING=OFF
		-DUSE_DCMTK=$(usex dicom)
		-DUSE_EXTERNAL_PUGIXML=ON
		-DUSE_JPEGTURBO=ON
		-DUSE_NUKE=OFF # not in Gentoo
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FIELD3D=$(usex field3d)
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
