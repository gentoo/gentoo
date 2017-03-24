# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit cmake-utils python-single-r1 vcs-snapshot

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="https://sites.google.com/site/openimageio/ https://github.com/OpenImageIO"
SRC_URI="https://github.com/OpenImageIO/oiio/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="colorio doc ffmpeg field3d gif jpeg opencv opengl ptex python qt4 raw ssl +truetype ${CPU_FEATURES[@]%:*}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test" #431412

RDEPEND=">=dev-libs/boost-1.62:=[python?,${PYTHON_USEDEP}]
	dev-libs/pugixml:=
	media-libs/ilmbase:=
	media-libs/libpng:0=
	>=media-libs/libwebp-0.2.1:=
	media-libs/openexr:=
	media-libs/tiff:0=
	sys-libs/zlib:=
	virtual/jpeg:0
	colorio? ( >=media-libs/opencolorio-1.0.7:= )
	ffmpeg? ( media-video/ffmpeg:= )
	field3d? ( media-libs/Field3D )
	gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg:= )
	opencv? (
		>=media-libs/opencv-2.3:=
		python? ( >=media-libs/opencv-2.4.8[python,${PYTHON_USEDEP}] )
	)
	opengl? (
		virtual/glu
		virtual/opengl
	)
	ptex? ( media-libs/ptex:= )
	python? ( ${PYTHON_DEPS} )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		media-libs/glew:=
	)
	raw? ( media-libs/libraw:= )
	ssl? ( dev-libs/openssl:0= )
	truetype? ( media-libs/freetype:2= )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[latex] )"

DOCS=( src/doc/${PN}.pdf )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	use python && python_fix_shebang .
}

src_configure() {
	# Build with SIMD support
	local cpufeature
	local mysimd=""
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use ${cpufeature%:*} && mysimd+="${cpufeature#*:},"
	done

	# If no CPU SIMDs were used, completely disable them
	[[ -z $mysimd ]] && mysimd="0"

	local mycmakeargs=(
		-DLIB_INSTALL_DIR="/usr/$(get_libdir)"
		-DOIIO_BUILD_TESTS=OFF # as they are RESTRICTed
		$(use python && echo -DPYLIB_INSTALL_DIR="$(python_get_sitedir)")
		-DSTOP_ON_WARNING=OFF
		-DUSE_NUKE=OFF
		-DUSE_EXTERNAL_PUGIXML=ON
		-DUSE_CPP14=ON
		-DUSE_FIELD3D=$(usex field3d)
		-DINSTALL_DOCS=$(usex doc)
		-DUSE_FREETYPE=$(usex truetype)
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_GIF=$(usex gif)
		-DUSE_OCIO=$(usex colorio)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENGL=$(usex opengl)
		-DUSE_JPEGTURBO=$(usex jpeg)
		-DUSE_OPENJPEG=$(usex jpeg)
		-DUSE_OPENSSL=$(usex ssl)
		-DUSE_PTEX=$(usex ptex)
		-DUSE_PYTHON=$(usex python)
		-DUSE_LIBRAW=$(usex raw)
		-DUSE_QT=$(usex qt4)
		-DUSE_SIMD=${mysimd%,}
		-DVERBOSE=ON
	)

	if [[ ${EPYTHON} == python3* ]]; then
		mycmakeargs+=( -DUSE_PYTHON3=ON -DPYTHON3_VERSION="${EPYTHON/python/}" )
	else
		mycmakeargs+=( -DUSE_PYTHON3=OFF -DPYTHON_VERSION="${EPYTHON/python/}" )
	fi

	cmake-utils_src_configure
}
