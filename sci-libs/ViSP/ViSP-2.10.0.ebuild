# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Visual Servoing Platform: visual tracking and visual servoing library"
HOMEPAGE="http://www.irisa.fr/lagadic/visp/visp.html"
SRC_URI="http://gforge.inria.fr/frs/download.php/latestfile/475/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="
	demos +dmtx doc examples ffmpeg gsl ieee1394 jpeg lapack ogre ois opencv png
	test tutorials usb v4l X xml +zbar zlib
"

RDEPEND="
	dmtx? ( media-libs/libdmtx )
	ffmpeg? ( virtual/ffmpeg )
	gsl? ( sci-libs/gsl )
	ieee1394? ( media-libs/libdc1394 )
	jpeg? ( virtual/jpeg:0 )
	lapack? ( virtual/lapack )
	ogre? ( dev-games/ogre[ois?] dev-libs/boost:=[threads] )
	opencv? ( media-libs/opencv )
	png? ( media-libs/libpng:0= )
	usb? ( virtual/libusb:1 )
	v4l? ( media-libs/libv4l )
	X? ( x11-libs/libX11 )
	xml? ( dev-libs/libxml2 )
	zbar? ( media-gfx/zbar )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen virtual/latex-base media-gfx/graphviz )
	virtual/pkgconfig
	test? ( sci-misc/ViSP-images )
	v4l? ( virtual/os-headers )"
RDEPEND="${RDEPEND}
	demos? ( sci-misc/ViSP-images )"
REQUIRED_USE="ffmpeg? ( opencv ) ois? ( ogre )"
PATCHES=( "${FILESDIR}/opencv.patch" "${FILESDIR}/opencv3.patch" )

src_configure() {
	local mycmakeargs=(
		"-DBUILD_EXAMPLES=$(usex examples ON OFF)"
		"-DBUILD_TESTS=$(usex test ON OFF)"
		"-DBUILD_DEMOS=$(usex demos ON OFF)"
		"-DBUILD_TUTORIALS=$(usex tutorials ON OFF)"
		"-DUSE_V4L2=$(usex v4l ON OFF)"
		"-DUSE_DC1394=$(usex ieee1394 ON OFF)"
		"-DUSE_LAPACK=$(usex lapack ON OFF)"
		"-DUSE_GSL=$(usex gsl ON OFF)"
		"-DUSE_OGRE=$(usex ogre ON OFF)"
		"-DUSE_OIS=$(usex ois ON OFF)"
		"-DUSE_LIBUSB_1=$(usex usb ON OFF)"
		"-DUSE_XML2=$(usex xml ON OFF)"
		"-DUSE_OPENCV=$(usex opencv ON OFF)"
		"-DUSE_ZLIB=$(usex zlib ON OFF)"
		"-DUSE_X11=$(usex X ON OFF)"
		"-DUSE_LIBJPEG=$(usex jpeg ON OFF)"
		"-DUSE_LIBPNG=$(usex png ON OFF)"
		"-DUSE_FFMPEG=$(usex ffmpeg ON OFF)"
		"-DUSE_ZBAR=$(usex zbar ON OFF)"
		"-DUSE_DMTX=$(usex dmtx ON OFF)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	cd "${BUILD_DIR}"
	use doc && emake visp_doc
}

src_install() {
	cmake-utils_src_install
	if use tutorials ; then
		dodoc -r tutorial
		docompress -x /usr/share/doc/${PF}/tutorial
	fi
	cd "${BUILD_DIR}"
	use doc && dohtml -r doc/html/*
}
