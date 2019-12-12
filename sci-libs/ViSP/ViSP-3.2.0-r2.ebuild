# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="Visual Servoing Platform: visual tracking and visual servoing library"
HOMEPAGE="http://www.irisa.fr/lagadic/visp/visp.html"
SRC_URI="http://gforge.inria.fr/frs/download.php/latestfile/475/visp-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0/3.2"
KEYWORDS="~amd64 ~arm"
IUSE="
	+coin demos +dmtx doc examples gsl ieee1394 jpeg lapack motif ogre
	opencv png test tutorials usb v4l X xml +zbar zlib
	cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3
"
RESTRICT="!test? ( test )"

RDEPEND="
	coin? ( >=media-libs/coin-4 virtual/opengl )
	dmtx? ( media-libs/libdmtx )
	gsl? ( sci-libs/gsl )
	ieee1394? ( media-libs/libdc1394 )
	jpeg? ( virtual/jpeg:0 )
	lapack? ( virtual/lapack )
	motif? ( media-libs/SoXt )
	ogre? ( dev-games/ogre[ois(+)] dev-libs/boost:=[threads] )
	opencv? ( media-libs/opencv:=[contribdnn(+)] )
	png? ( media-libs/libpng:0= )
	usb? ( virtual/libusb:1 )
	v4l? ( media-libs/libv4l )
	X? ( x11-libs/libX11 )
	xml? ( dev-libs/libxml2 )
	zbar? ( media-gfx/zbar )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen virtual/latex-base media-gfx/graphviz )
	test? ( sci-misc/ViSP-images )
	v4l? ( virtual/os-headers )"
RDEPEND="${RDEPEND}
	demos? ( sci-misc/ViSP-images )"
REQUIRED_USE="motif? ( coin )"

S="${WORKDIR}/visp-${PV}"
PATCHES=( "${FILESDIR}/${PN}-3.2.0-ocv.patch" "${FILESDIR}/${PN}-3.0.1-opencv.patch" )

src_configure() {
	local mycmakeargs=(
		"-DBUILD_EXAMPLES=$(usex examples ON OFF)"
		"-DBUILD_TESTS=$(usex test ON OFF)"
		"-DBUILD_DEMOS=$(usex demos ON OFF)"
		"-DBUILD_TUTORIALS=$(usex tutorials ON OFF)"
		"-DUSE_COIN3D=$(usex coin ON OFF)"
		"-DUSE_DC1394=$(usex ieee1394 ON OFF)"
		"-DUSE_DMTX=$(usex dmtx ON OFF)"
		"-DUSE_GSL=$(usex gsl ON OFF)"
		"-DUSE_LAPACK=$(usex lapack ON OFF)"
		"-DUSE_JPEG=$(usex jpeg ON OFF)"
		"-DUSE_PNG=$(usex png ON OFF)"
		"-DUSE_LIBUSB_1=$(usex usb ON OFF)"
		"-DUSE_OGRE=$(usex ogre ON OFF)"
		"-DUSE_OIS=$(usex ogre ON OFF)"
		"-DUSE_OPENCV=$(usex opencv ON OFF)"
		"-DUSE_SOQT=OFF"
		"-DUSE_SOXT=$(usex motif ON OFF)"
		"-DUSE_V4L2=$(usex v4l ON OFF)"
		"-DUSE_X11=$(usex X ON OFF)"
		"-DUSE_XML2=$(usex xml ON OFF)"
		"-DUSE_ZBAR=$(usex zbar ON OFF)"
		"-DUSE_ZLIB=$(usex zlib ON OFF)"
		"-DCOIN3D_INCLUDE_DIR=${EPREFIX:-${SYSROOT}}/usr/include/Coin4"
		"-DENABLE_SSE2=$(usex cpu_flags_x86_sse2 ON OFF)"
		"-DENABLE_SSE3=$(usex cpu_flags_x86_sse3 ON OFF)"
		"-DENABLE_SSSE3=$(usex cpu_flags_x86_ssse3 ON OFF)"
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
