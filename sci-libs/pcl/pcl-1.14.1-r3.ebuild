# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake cuda

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PointCloudLibrary/pcl"
else
	SRC_URI="https://github.com/PointCloudLibrary/pcl/archive/${P}.tar.gz"
	S="${WORKDIR}/${PN}-${P}"
	KEYWORDS="amd64 ~arm"
fi

DESCRIPTION="2D/3D image and point cloud processing"
HOMEPAGE="https://pointclouds.org/"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
IUSE="cuda doc opengl openni openni2 pcap png +qhull qt6 usb vtk cpu_flags_x86_sse test tutorials"

REQUIRED_USE="
	openni? ( usb )
	openni2? ( usb )
	tutorials? ( doc )
"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=
	dev-cpp/eigen:=
	>=sci-libs/flann-1.7.1
	opengl? (
		media-libs/freeglut
		virtual/opengl
	)
	openni? ( dev-libs/OpenNI )
	openni2? ( dev-libs/OpenNI2 )
	pcap? ( net-libs/libpcap )
	png? ( media-libs/libpng:0= )
	qhull? ( media-libs/qhull:= )
	qt6? (
		dev-qt/qtbase:6[concurrent,gui,opengl]
		vtk? ( sci-libs/vtk[-qt5(-),qt6] )
	)
	usb? ( virtual/libusb:1 )
	vtk? ( >=sci-libs/vtk-5.6:=[imaging,rendering,views] )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4 )
"
DEPEND="${RDEPEND}
	!!dev-cpp/metslib
	test? ( dev-cpp/gtest )
"
BDEPEND="
	doc? (
		app-text/doxygen[dot]
		virtual/latex-base
	)
	tutorials? (
		dev-python/sphinx
		dev-python/sphinx-rtd-theme
		dev-python/sphinxcontrib-doxylink
	)
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.12.1-allow-configuration-of-install-dirs.patch
	"${FILESDIR}"/${PN}-1.12.1-fix-hardcoded-relative-directory-of-the-installed-cmake-files.patch
	"${FILESDIR}"/${PN}-1.14.1-gcc15.patch
	"${FILESDIR}"/${PN}-1.14.1-tests.patch
	"${FILESDIR}"/${PN}-1.14.1-boostconfig.patch # bug 969095, in 1.15
	"${FILESDIR}"/${PN}-1.14.1-boost-1.{86,87,89}.patch # in 1.15; 1.89 fix in git master
)

src_prepare() {
	if use cuda; then
		cuda_src_prepare
		cuda_add_sandbox -w
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DDOC_INSTALL_DIR=share/doc/${PF}"
		"-DLIB_INSTALL_DIR=$(get_libdir)"
		"-DPCLCONFIG_INSTALL_DIR=share/cmake/${PN}-$(ver_cut 1-2)"
		"-DWITH_CUDA=$(usex cuda TRUE FALSE)"
		"-DWITH_LIBUSB=$(usex usb TRUE FALSE)"
		"-DWITH_OPENGL=$(usex opengl TRUE FALSE)"
		"-DWITH_PNG=$(usex png TRUE FALSE)"
		"-DWITH_QHULL=$(usex qhull TRUE FALSE)"
		"-DWITH_VTK=$(usex vtk TRUE FALSE)"
		"-DWITH_PCAP=$(usex pcap TRUE FALSE)"
		"-DWITH_OPENNI=$(usex openni TRUE FALSE)"
		"-DWITH_OPENNI2=$(usex openni2 TRUE FALSE)"
		"-DPCL_ENABLE_SSE=$(usex cpu_flags_x86_sse TRUE FALSE)"
		"-DWITH_DOCS=$(usex doc TRUE FALSE)"
		"-DWITH_TUTORIALS=$(usex tutorials TRUE FALSE)"
		-DBUILD_global_tests="$(usex test)"
	)

	if use qt6; then
		mycmakeargs+=( "-DWITH_QT=QT6" )
	else
		mycmakeargs+=( "-DWITH_QT=NO" )
	fi

	cmake_src_configure
}

src_test() {
	BUILD_DIR="${BUILD_DIR}/test" cmake_src_test
}
