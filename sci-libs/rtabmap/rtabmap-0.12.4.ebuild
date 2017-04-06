# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/introlab/rtabmap"
fi

inherit ${SCM} cmake-utils multilib

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/introlab/rtabmap/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Real-Time Appearance-Based Mapping (RGB-D Graph SLAM)"
HOMEPAGE="http://introlab.github.io/rtabmap/"
LICENSE="BSD"
SLOT="0"
IUSE="examples ieee1394 openni2 qt5"

RDEPEND="
	media-libs/opencv:=[qt5(-)?]
	sci-libs/pcl:=[openni,vtk]
	sci-libs/vtk:=[qt5(-)?]
	sys-libs/zlib
	sci-libs/octomap:=
	ieee1394? ( media-libs/libdc1394 )
	openni2? ( dev-libs/OpenNI2 )
	qt5? (
		dev-qt/qtwidgets:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		"-DWITH_QT=$(usex qt5 ON OFF)"
		"-DWITH_DC1394=$(usex ieee1394 ON OFF)"
		"-DWITH_OPENNI2=$(usex openni2 ON OFF)"
		"-DBUILD_EXAMPLES=$(usex examples ON OFF)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# Needed since we force ros crawling to be done only in
	# /usr/share/ros_packages/
	insinto /usr/share/ros_packages/${PN}
	doins "${ED}/usr/share/${PN}/package.xml"
}
