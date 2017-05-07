# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils versionator vcs-snapshot flag-o-matic

DESCRIPTION="A 3D multiple robot simulator with dynamics"
HOMEPAGE="http://gazebosim.org/"
SRC_URI="https://osrf-distributions.s3.amazonaws.com/gazebo/releases/${P}.tar.bz2"

LICENSE="Apache-2.0"
# Subslot = major version = soname of libs
SLOT="0/8"
KEYWORDS="~amd64"
IUSE="cpu_flags_x86_sse2 libav test"

RDEPEND="
	>=dev-libs/protobuf-2:=
	virtual/opengl
	media-libs/openal
	net-misc/curl
	dev-libs/tinyxml
	dev-libs/tinyxml2
	dev-libs/libtar
	dev-cpp/tbb
	>=dev-games/ogre-1.7.4[freeimage]
	>=media-libs/freeimage-3.15.4[png]
	sci-libs/libccd
	libav? ( >=media-video/libav-9:0= )
	!libav? ( >=media-video/ffmpeg-2.6:0= )
	sci-libs/gts
	>=sci-physics/bullet-2.82
	>=dev-libs/sdformat-5.0:=
	dev-qt/qtwidgets:5
	dev-qt/qtcore:5
	dev-qt/qtopengl:5
	dev-libs/boost:=[threads]
	sci-libs/gdal
	virtual/libusb:1
	dev-libs/libspnav
	media-libs/freeimage
	sci-libs/hdf5:=[cxx]
	sys-apps/util-linux
	media-gfx/graphviz
	net-libs/ignition-msgs:=
	>=sci-libs/ignition-math-2.3:3=
	net-libs/ignition-transport:3=
	x11-libs/qwt:6=[qt5]
"
DEPEND="${RDEPEND}
	dev-qt/qttest:5
	app-text/ronn
	app-arch/gzip
	virtual/pkgconfig
	x11-apps/mesa-progs
	test? ( dev-libs/libxslt )
"
CMAKE_BUILD_TYPE=RelWithDebInfo
PATCHES=( "${FILESDIR}/qwt.patch" )

src_configure() {
	# doesnt build without it
	append-cxxflags "-std=c++11"
	# doesnt build with as-needed either
	append-ldflags "-Wl,--no-as-needed"

	local mycmakeargs=(
		"-DUSE_UPSTREAM_CFLAGS=OFF"
		"-DSSE2_FOUND=$(usex cpu_flags_x86_sse2 TRUE FALSE)"
		"-DUSE_HOST_CFLAGS=FALSE"
		"-DBUILD_TESTING=$(usex test TRUE FALSE)"
		"-DENABLE_SCREEN_TESTS=FALSE"
		"-DUSE_EXTERNAL_TINYXML2=TRUE"
	)
	cmake-utils_src_configure
}
