# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils versionator vcs-snapshot flag-o-matic

DESCRIPTION="A 3D multiple robot simulator with dynamics"
HOMEPAGE="http://gazebosim.org/"
SRC_URI="http://osrf-distributions.s3.amazonaws.com/gazebo/releases/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cpu_flags_x86_sse2 libav test"

RDEPEND="
	=dev-libs/protobuf-2*:=
	virtual/opengl
	media-libs/openal
	net-misc/curl
	dev-libs/tinyxml
	dev-libs/tinyxml2
	dev-libs/libtar
	dev-cpp/tbb
	>=dev-games/ogre-1.7.4
	sci-libs/libccd
	libav? ( >=media-video/libav-9:0= )
	!libav? ( >=media-video/ffmpeg-2.6:0= )
	sci-libs/gts
	>=sci-physics/bullet-2.82
	>=dev-libs/sdformat-4.1:=
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
	dev-qt/qtxmlpatterns:4
	dev-libs/boost:=[threads]
	sci-libs/gdal
	virtual/libusb:1
	dev-libs/libspnav
	media-libs/freeimage
	sci-libs/hdf5:=
	sys-apps/util-linux
	media-gfx/graphviz
	>=sci-libs/ignition-math-2.3:2=
	net-libs/ignition-transport:=
"
DEPEND="${RDEPEND}
	dev-qt/qttest:4
	app-text/ronn
	virtual/pkgconfig
	x11-apps/mesa-progs
	test? ( dev-libs/libxslt )
"
CMAKE_BUILD_TYPE=RelWithDebInfo
PATCHES=( "${FILESDIR}/tinyxml2.patch" )

src_configure() {
	# doesnt build without it
	append-cxxflags "-std=c++11"
	# doesnt build with as-needed either
	append-ldflags "-Wl,--no-as-needed"

	local mycmakeargs=(
		"-DUSE_UPSTREAM_CFLAGS=OFF"
		"-DSSE2_FOUND=$(usex cpu_flags_x86_sse2 TRUE FALSE)"
		"-DUSE_HOST_CFLAGS=FALSE"
		"-DENABLE_TESTS_COMPILATION=$(usex test TRUE FALSE)"
		"-DENABLE_SCREEN_TESTS=FALSE"
		"-DUSE_EXTERNAL_TINYXML2=TRUE"
	)
	cmake-utils_src_configure
}
