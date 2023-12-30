# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake cuda toolchain-funcs

if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PointCloudLibrary/pcl"
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://github.com/PointCloudLibrary/pcl/archive/${P}.tar.gz"
	S="${WORKDIR}/${PN}-${P}"
fi

HOMEPAGE="https://pointclouds.org/"
DESCRIPTION="2D/3D image and point cloud processing"
LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
IUSE="cuda doc opengl openni openni2 pcap png +qhull qt5 usb vtk cpu_flags_x86_sse test tutorials"
# tests need the gtest sources to be available at build time
RESTRICT="test"

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
	vtk? ( >=sci-libs/vtk-5.6:=[imaging,rendering,views] )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4 )
"
DEPEND="${RDEPEND}
	!!dev-cpp/metslib
"
BDEPEND="
	doc? (
		app-doc/doxygen[dot]
		virtual/latex-base
	)
	tutorials? (
		dev-python/sphinx
		dev-python/sphinx-rtd-theme
		dev-python/sphinxcontrib-doxylink
	)
	virtual/pkgconfig"

REQUIRED_USE="
	openni? ( usb )
	openni2? ( usb )
	tutorials? ( doc )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.12.1-allow-configuration-of-install-dirs.patch"
	"${FILESDIR}/${PN}-1.12.1-fix-hardcoded-relative-directory-of-the-installed-cmake-files.patch"
)

cuda_set_CUDAHOSTCXX() {
	local compiler
	tc-is-gcc && compiler="gcc"
	tc-is-clang && compiler="clang"
	[[ -z "$compiler" ]] && die "no compiler specified"

	local package="sys-devel/${compiler}"
	local version="${package}"
	local CUDAHOSTCXX_test
	while
		CUDAHOSTCXX="${CUDAHOSTCXX_test}"
		version=$(best_version "${version}")
		if [[ -z "${version}" ]]; then
			if [[ -z "${CUDAHOSTCXX}" ]]; then
				die "could not find supported version of ${package}"
			fi
			break
		fi
		CUDAHOSTCXX_test="$(
			dirname "$(
				realpath "$(
					which "${compiler}-$(echo "${version}" | grep -oP "(?<=${package}-)[0-9]*")"
				)"
			)"
		)"
		version="<${version}"
	do ! echo "int main(){}" | nvcc "-ccbin ${CUDAHOSTCXX_test}" - -x cu &>/dev/null; done

	export CUDAHOSTCXX
}

cuda_get_host_arch() {
	[[ -z "${CUDAARCHS}" ]] && einfo "trying to determine host CUDAARCHS"
	: "${CUDAARCHS:=$(__nvcc_device_query)}"
	einfo "building for CUDAARCHS = ${CUDAARCHS}"

	export CUDAARCHS
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	if use cuda; then
		cuda_add_sandbox -w
		cuda_set_CUDAHOSTCXX
		cuda_get_host_arch
	fi

	local mycmakeargs=(
		"-DDOC_INSTALL_DIR=share/doc/${PF}"
		"-DLIB_INSTALL_DIR=$(get_libdir)"
		"-DPCLCONFIG_INSTALL_DIR=share/cmake/${PN}-$(ver_cut 1-2)"
		"-DWITH_CUDA=$(usex cuda)"
		"-DWITH_LIBUSB=$(usex usb)"
		"-DWITH_OPENGL=$(usex opengl)"
		"-DWITH_PNG=$(usex png)"
		"-DWITH_QHULL=$(usex qhull)"
		"-DWITH_QT=$(usex qt5)"
		"-DWITH_VTK=$(usex vtk)"
		"-DWITH_PCAP=$(usex pcap)"
		"-DWITH_OPENNI=$(usex openni)"
		"-DWITH_OPENNI2=$(usex openni2)"
		"-DPCL_ENABLE_SSE=$(usex cpu_flags_x86_sse)"
		"-DWITH_DOCS=$(usex doc)"
		"-DWITH_TUTORIALS=$(usex tutorials)"
		"-DBUILD_global_tests=FALSE"
	)

	cmake_src_configure
}
