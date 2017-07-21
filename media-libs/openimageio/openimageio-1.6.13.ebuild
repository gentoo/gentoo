# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit cmake-utils python-single-r1 vcs-snapshot

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="https://sites.google.com/site/openimageio/ https://github.com/OpenImageIO"
SRC_URI="https://github.com/OpenImageIO/oiio/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="colorio ffmpeg gif jpeg2k opencv opengl python qt4 raw ssl +truetype"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="test" #431412

RDEPEND="
	dev-libs/boost:=
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
	gif? ( media-libs/giflib:0= )
	jpeg2k? ( >=media-libs/openjpeg-1.5:0= )
	opencv? (
		>=media-libs/opencv-2.3:=
		python? ( >=media-libs/opencv-2.4.8[python,${PYTHON_USEDEP}] )
	)
	opengl? (
		virtual/glu
		virtual/opengl
	)
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
	raw? ( media-libs/libraw:= )
	ssl? ( dev-libs/openssl:0 )
	truetype? ( media-libs/freetype:2= )"
DEPEND="${RDEPEND}"

#S=${WORKDIR}/${P}/src

DOCS=( CHANGES CREDITS README.rst src/doc/${PN}.pdf )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	use python && python_fix_shebang .
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="/usr/$(get_libdir)"
		-DBUILDSTATIC=OFF
		-DLINKSTATIC=OFF
		-DINSTALL_DOCS=OFF
		-DOIIO_BUILD_TESTS=OFF # as they are RESTRICTed
		$(use python && echo -DPYLIB_INSTALL_DIR="$(python_get_sitedir)")
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
		-DUSE_PYTHON=$(usex python)
		-DUSE_LIBRAW=$(usex raw)
		-DUSE_QT=$(usex qt4)
	)

	if [[ ${EPYTHON} == python3* ]]; then
		mycmakeargs+=( -DUSE_PYTHON3=ON )
	else
		mycmakeargs+=( -DUSE_PYTHON3=OFF )
	fi

	cmake-utils_src_configure
}
