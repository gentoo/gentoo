# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit cmake-utils vcs-snapshot python-single-r1

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="https://sites.google.com/site/openimageio/ https://github.com/OpenImageIO"
SRC_URI="https://github.com/OpenImageIO/oiio/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

X86_CPU_FEATURES=( sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2 )
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="colorio doc ffmpeg field3d gif jpeg2k opencv opengl ptex python qt4 raw ssl +truetype ${CPU_FEATURES[@]%:*}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="test" #431412

RDEPEND="dev-libs/boost:=
	dev-libs/pugixml:0=
	media-libs/ilmbase:=
	media-libs/libpng:0=
	>=media-libs/libwebp-0.2.1:=
	media-libs/openexr:=
	media-libs/tiff:0=
	sys-libs/zlib:=
	virtual/jpeg:=
	colorio? ( media-libs/opencolorio:0= )
	ffmpeg? ( media-video/ffmpeg:0= )
	field3d? ( media-libs/Field3D )
	gif? ( media-libs/giflib:0= )
	jpeg2k? ( >=media-libs/openjpeg-1.5:0= )
	opencv? ( media-libs/opencv:= )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	ptex? ( media-libs/ptex )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:=[python,${PYTHON_USEDEP}]
	)
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		media-libs/glew:=
	)
	raw? ( media-libs/libraw:0= )
	ssl? ( dev-libs/openssl:0= )
	truetype? ( media-libs/freetype:2= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-use-gnuinstalldirs.patch"
	"${FILESDIR}/${P}-make-python-and-boost-detection-more-generic.patch"
	"${FILESDIR}/${P}-repair-breaks-after-boost-python-1.65-changes.patch"
)

DOCS=( CHANGES CREDITS README.rst src/doc/${PN}.pdf )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	# Build with SIMD support (choices: 0, sse2, sse3,"
	#	ssse3, sse4.1, sse4.2)"
	local cpufeature
	local mysimd=()
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
	done
	# If no CPU SIMDs were used, completely disable them
	-z ${mysimd} ]] && mysimd=("0")

	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DINSTALL_DOCS=$(usex doc)
		-DOIIO_BUILD_CPP11=ON
		-DOIIO_BUILD_TESTS=OFF # as they are RESTRICTed
		-DSTOP_ON_WARNING=OFF
		-DUSE_EXTERNAL_PUGIXML=ON
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FIELD3D=$(usex field3d)
		-DUSE_FREETYPE=$(usex truetype)
		-DUSE_GIF=$(usex gif)
		-DUSE_JPEGTURBO=ON
		-DUSE_LIBRAW=$(usex raw)
		-DUSE_NUKE=NO # Missing in Gentoo
		-DUSE_OCIO=$(usex colorio)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENGL=$(usex opengl)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_OPENSSL=$(usex ssl)
		-DUSE_PTEX=$(usex ptex)
		-DUSE_PYTHON=$(usex python)
		-DUSE_QT=$(usex qt4)
		-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
	)

	cmake-utils_src_configure
}
