# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/PointCloudLibrary/pcl"
fi

inherit ${SCM} cmake multilib

if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
else
	KEYWORDS="amd64 ~arm"
	SRC_URI="https://github.com/PointCloudLibrary/pcl/archive/${P}.tar.gz"
	S="${WORKDIR}/${PN}-${P}"
fi

HOMEPAGE="https://pointclouds.org/"
DESCRIPTION="2D/3D image and point cloud processing"
LICENSE="BSD"
SLOT="0/1.12"
IUSE="cuda doc opengl openni openni2 pcap png +qhull qt5 usb vtk cpu_flags_x86_sse test tutorials"
RESTRICT="!test? ( test )"

RDEPEND="
	>=sci-libs/flann-1.7.1
	dev-libs/boost:=
	dev-cpp/eigen:3
	opengl? ( virtual/opengl media-libs/freeglut )
	openni? ( dev-libs/OpenNI )
	openni2? ( dev-libs/OpenNI2 )
	pcap? ( net-libs/libpcap )
	png? ( media-libs/libpng:0= )
	qhull? ( media-libs/qhull:= )
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtcore:5
		dev-qt/qtconcurrent:5
		dev-qt/qtopengl:5
	)
	usb? ( virtual/libusb:1 )
	vtk? ( >=sci-libs/vtk-5.6:=[imaging,rendering] )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4 )
"
DEPEND="${RDEPEND}
	!!dev-cpp/metslib
	test? ( >=dev-cpp/gtest-1.6.0 )
"
BDEPEND="
	doc? ( app-doc/doxygen )
	tutorials? ( dev-python/sphinx dev-python/sphinxcontrib-doxylink )
	virtual/pkgconfig"

REQUIRED_USE="
	openni? ( usb )
	openni2? ( usb )
	tutorials? ( doc )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.12.0-cmake-targets.patch
)

src_configure() {
	local mycmakeargs=(
		"-DLIB_INSTALL_DIR=$(get_libdir)"
		"-DWITH_CUDA=$(usex cuda TRUE FALSE)"
		"-DWITH_LIBUSB=$(usex usb TRUE FALSE)"
		"-DWITH_OPENGL=$(usex opengl TRUE FALSE)"
		"-DWITH_PNG=$(usex png TRUE FALSE)"
		"-DWITH_QHULL=$(usex qhull TRUE FALSE)"
		"-DWITH_QT=$(usex qt5 TRUE FALSE)"
		"-DWITH_VTK=$(usex vtk TRUE FALSE)"
		"-DWITH_PCAP=$(usex pcap TRUE FALSE)"
		"-DWITH_OPENNI=$(usex openni TRUE FALSE)"
		"-DWITH_OPENNI2=$(usex openni2 TRUE FALSE)"
		"-DPCL_ENABLE_SSE=$(usex cpu_flags_x86_sse TRUE FALSE)"
		"-DWITH_DOCS=$(usex doc TRUE FALSE)"
		"-DWITH_TUTORIALS=$(usex tutorials TRUE FALSE)"
		"-DBUILD_TESTS=$(usex test TRUE FALSE)"
	)
	cmake_src_configure
}
