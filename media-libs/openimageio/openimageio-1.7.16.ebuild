# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils vcs-snapshot

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

IUSE="colorio doc ffmpeg field3d gif jpeg opencv opengl ptex qt4 raw ssl +truetype ${CPU_FEATURES[@]%:*}"

RESTRICT="test" #431412

RDEPEND=">=dev-libs/boost-1.62:=
	dev-libs/pugixml:=
	>=media-libs/ilmbase-2.2.0-r1:=
	media-libs/libpng:0=
	>=media-libs/libwebp-0.2.1:=
	>=media-libs/openexr-2.2.0-r2:=
	media-libs/tiff:0=
	sys-libs/zlib:=
	virtual/jpeg:0
	colorio? ( >=media-libs/opencolorio-1.0.9:= )
	ffmpeg? ( media-video/ffmpeg:= )
	field3d? ( media-libs/Field3D )
	gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg:= )
	opencv? ( >=media-libs/opencv-2.3:= )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	ptex? ( media-libs/ptex:= )
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

PATCHES=( "${FILESDIR}/${P}-use-GNUInstallDirs.patch" )

DOCS=( src/doc/${PN}.pdf )

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
		-DOIIO_BUILD_TESTS=OFF # as they are RESTRICTed
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
		-DUSE_PYTHON=OFF
		-DUSE_PYTHON3=OFF
		-DUSE_LIBRAW=$(usex raw)
		-DUSE_QT=$(usex qt4)
		-DUSE_SIMD=${mysimd%,}
		-DVERBOSE=ON
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
	)

	cmake-utils_src_configure
}
