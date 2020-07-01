# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="A 3D multiple robot simulator with dynamics"
HOMEPAGE="http://gazebosim.org/"
SRC_URI="https://osrf-distributions.s3.amazonaws.com/gazebo/releases/${P}.tar.bz2"

LICENSE="Apache-2.0"
# Subslot = major version = soname of libs
SLOT="0/11"
KEYWORDS="~amd64"
IUSE="cpu_flags_x86_sse2 test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/protobuf-2:=
	virtual/opengl
	media-libs/openal
	net-misc/curl
	dev-libs/tinyxml
	>=dev-libs/tinyxml2-6:=
	dev-libs/libtar
	dev-cpp/tbb
	>=dev-games/ogre-1.7.4:=[freeimage]
	<dev-games/ogre-1.10
	>=media-libs/freeimage-3.15.4[png]
	sci-libs/libccd
	>=media-video/ffmpeg-2.6:0=
	sci-libs/gts
	>=sci-physics/bullet-2.82
	>=dev-libs/sdformat-9.1:=
	dev-qt/qtwidgets:5
	dev-qt/qtcore:5
	dev-qt/qtopengl:5
	dev-libs/boost:=[threads]
	sci-libs/gdal:=
	virtual/libusb:1
	dev-libs/libspnav
	media-libs/freeimage
	sci-libs/hdf5:=[cxx]
	sys-apps/util-linux
	media-gfx/graphviz
	net-libs/ignition-msgs:5=
	sci-libs/ignition-math:6=
	net-libs/ignition-transport:8=
	sci-libs/ignition-common:3=
	sci-libs/ignition-fuel-tools:4=
	x11-libs/qwt:6=[qt5(+)]
"
DEPEND="${RDEPEND}
	dev-qt/qttest:5
	x11-apps/mesa-progs
	test? ( dev-libs/libxslt )
"
BDEPEND="
	app-text/ronn
	app-arch/gzip
	virtual/pkgconfig
"
CMAKE_BUILD_TYPE=RelWithDebInfo
PATCHES=( "${FILESDIR}/qwt.patch" "${FILESDIR}/boost173.patch" "${FILESDIR}/cmake.patch" )

src_configure() {
	# doesnt build with as-needed
	#append-ldflags "-Wl,--no-as-needed"

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
