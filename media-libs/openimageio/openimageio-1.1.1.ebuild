# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/openimageio/openimageio-1.1.1.ebuild,v 1.12 2014/01/24 21:46:13 dilfridge Exp $

EAPI=5

PYTHON_DEPEND="python? 2:2.7"

inherit cmake-utils eutils multilib python vcs-snapshot

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="http://sites.google.com/site/openimageio/ http://github.com/OpenImageIO"
SRC_URI="http://github.com/OpenImageIO/oiio/tarball/Release-${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="jpeg2k colorio opencv opengl python qt4 tbb +truetype"

RESTRICT="test" #431412

RDEPEND="dev-libs/boost[python?]
	dev-libs/pugixml
	media-libs/glew
	media-libs/ilmbase
	media-libs/libpng:0
	>=media-libs/libwebp-0.2.1
	media-libs/openexr
	media-libs/tiff:0
	sci-libs/hdf5
	sys-libs/zlib
	virtual/jpeg
	jpeg2k? ( >=media-libs/openjpeg-1.5:0 )
	colorio? ( >=media-libs/opencolorio-1.0.7 )
	opencv? (
		>=media-libs/opencv-2.3
		|| ( <media-libs/opencv-2.4.8 >media-libs/opencv-2.4.8[python?] )
	)
	opengl? (
		virtual/glu
		virtual/opengl
		)
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		)
	tbb? ( dev-cpp/tbb )
	truetype? ( >=media-libs/freetype-2 )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}/src

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-x86-build.patch #444784

	# remove bundled code to make it build
	# https://github.com/OpenImageIO/oiio/issues/403
	rm */pugixml* || die

	# fix man page building
	# https://github.com/OpenImageIO/oiio/issues/404
	use qt4 || sed -i -e '/list.*APPEND.*cli_tools.*iv/d' doc/CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
		-DBUILDSTATIC=OFF
		-DLINKSTATIC=OFF
		$(use python && echo -DPYLIB_INSTALL_DIR=$(python_get_sitedir))
		-DUSE_EXTERNAL_PUGIXML=ON
		-DUSE_FIELD3D=OFF # missing in Portage
		$(cmake-utils_use_use truetype freetype)
		$(cmake-utils_use_use colorio OCIO)
		$(cmake-utils_use_use opencv)
		$(cmake-utils_use_use opengl)
		$(cmake-utils_use_use jpeg2k OPENJPEG)
		$(cmake-utils_use_use python)
		$(cmake-utils_use_use qt4 QT)
		$(cmake-utils_use_use tbb)
		)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	rm -rf "${ED}"/usr/share/doc
	dodoc ../{CHANGES,CREDITS,README*} # doc/CLA-{CORPORATE,INDIVIDUAL}
	docinto pdf
	dodoc doc/*.pdf
}
