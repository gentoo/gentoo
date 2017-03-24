# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils vcs-snapshot

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="https://sites.google.com/site/openimageio/ https://github.com/OpenImageIO"
SRC_URI="https://github.com/OpenImageIO/oiio/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

X86_CPU_FEATURES=( sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2 )
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )
IUSE="colorio ffmpeg gif jpeg2k opencv opengl ptex qt4 raw ssl +truetype ${CPU_FEATURES[@]%:*}"

RESTRICT="test" #431412

RDEPEND="dev-libs/boost:=
	dev-libs/pugixml:0=
	media-libs/ilmbase:=
	media-libs/libpng:0=
	>=media-libs/libwebp-0.2.1:=
	media-libs/openexr:=
	media-libs/tiff:0=
	sys-libs/zlib:0=
	virtual/jpeg:0=
	colorio? ( >=media-libs/opencolorio-1.0.7:0= )
	ffmpeg? ( media-video/ffmpeg:0= )
	gif? ( media-libs/giflib:0= )
	jpeg2k? ( >=media-libs/openjpeg-1.5:0= )
	opencv? ( media-libs/opencv:= )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	ptex? ( media-libs/ptex )
	qt4? (
		dev-qt/qtcore:4=
		dev-qt/qtgui:4=
		dev-qt/qtopengl:4=
		media-libs/glew:=
	)
	raw? ( media-libs/libraw:0= )
	ssl? ( dev-libs/openssl:0= )
	truetype? ( media-libs/freetype:2= )"
DEPEND="${RDEPEND}"

DOCS=( CHANGES CREDITS README.rst src/doc/${PN}.pdf )

src_prepare() {
	cmake-utils_src_prepare

	# Add more Boost versions.
	sed -e 's|"1.60"|"1.63" "1.62" "1.61" "1.60"|' \
	    -i src/cmake/externalpackages.cmake || die
}

src_configure() {
	# Build with SIMD support (choices: 0, sse2, sse3,"
	#	ssse3, sse4.1, sse4.2)"
	local mysimd=""
	local cpufeature
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use ${cpufeature%:*} && mysimd+="${cpufeature#*:},"
	done
	# If no CPU SIMDs were used, completely disable them
	[[ -z $mysimd ]] && mysimd="0"

	local mycmakeargs=(
		-DLIB_INSTALL_DIR="/usr/$(get_libdir)"
		-DBUILDSTATIC=OFF
		-DLINKSTATIC=OFF
		-DINSTALL_DOCS=OFF
		-DOIIO_BUILD_TESTS=OFF # as they are RESTRICTed
		-DSTOP_ON_WARNING=OFF
		-DUSE_EXTERNAL_PUGIXML=ON
		-DUSE_FIELD3D=OFF # missing in Portage
		-DUSE_FREETYPE=$(usex truetype)
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_GIF=$(usex gif)
		-DUSE_OCIO=$(usex colorio)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENGL=$(usex opengl)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_OPENSSL=$(usex ssl)
		-DUSE_LIBRAW=$(usex raw)
		-DUSE_PTEX=$(usex ptex)
		-DUSE_QT=$(usex qt4)
		-DOIIO_BUILD_CPP11=ON
		-DUSE_SIMD="${mysimd%,}"
		-DUSE_PYTHON=OFF # Seriously broken.
	)

	cmake-utils_src_configure
}
