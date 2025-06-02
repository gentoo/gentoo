# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VER_SUFFIX=noetic
inherit cmake

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/introlab/rtabmap"
else
	SRC_URI="https://github.com/introlab/rtabmap/archive/refs/tags/${PV}-${VER_SUFFIX}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P}-${VER_SUFFIX}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Real-Time Appearance-Based Mapping (RGB-D Graph SLAM)"
HOMEPAGE="https://introlab.github.io/rtabmap/"

LICENSE="BSD"
SLOT="0"
IUSE="examples ieee1394 openni2 qt6"

RDEPEND="
	dev-cpp/yaml-cpp:=
	dev-libs/boost:=
	media-libs/opencv:=[qt6(-)?]
	sci-libs/octomap:=
	sci-libs/pcl:=[openni,vtk,qt6(-)?]
	sci-libs/vtk:=[qt6(-)?]
	sys-libs/zlib
	ieee1394? ( media-libs/libdc1394:2= )
	openni2? ( dev-libs/OpenNI2 )
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		dev-qt/qtsvg:6
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DRTABMAP_QT_VERSION=6
		-DWITH_QT=$(usex qt6)
		-DWITH_DC1394=$(usex ieee1394)
		-DWITH_OPENNI2=$(usex openni2)
		-DBUILD_EXAMPLES=$(usex examples)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	# Needed since we force ros crawling to be done only in
	# /usr/share/ros_packages/
	insinto /usr/share/ros_packages/${PN}
	doins "${ED}/usr/share/${PN}/package.xml"
}
