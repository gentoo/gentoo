# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
IUSE="ieee1394 openni2 qt4 qt5"

RDEPEND="
	media-libs/opencv:=
	sci-libs/pcl[openni,vtk]
	sci-libs/vtk
	sys-libs/zlib
	ieee1394? ( media-libs/libdc1394 )
	openni2? ( dev-libs/OpenNI2 )
	!qt5? (
		qt4? (
			dev-qt/qtgui:4
			dev-qt/qtsvg:4
			dev-qt/qtcore:4
			media-libs/opencv[-qt5(-)]
		)
	)
	qt5? (
		dev-qt/qtwidgets:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		media-libs/opencv[qt5(-)]
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		"-DWITH_QT=$(usex qt4 ON "$(usex qt5 ON OFF)")"
		"-DRTABMAP_QT_VERSION=$(usex qt5 5 4)"
		"-DWITH_DC1394=$(usex ieee1394 ON OFF)"
		"-DWITH_OPENNI2=$(usex openni2 ON OFF)"
	)
	cmake-utils_src_configure
}
