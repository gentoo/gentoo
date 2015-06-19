# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/rtabmap/rtabmap-9999.ebuild,v 1.3 2015/05/18 07:53:59 aballier Exp $

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
	sci-libs/pcl[openni]
	sci-libs/vtk
	sys-libs/zlib
	ieee1394? ( media-libs/libdc1394 )
	openni2? ( dev-libs/OpenNI2 )
	!qt5? (
		qt4? (
			dev-qt/qtgui:4
			dev-qt/qtsvg:4
			dev-qt/qtcore:4
		)
	)
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
	local mycmakeargs=()
	use ieee1394 || mycmakeargs+=( "-DCMAKE_DISABLE_FIND_PACKAGE_DC1394=TRUE" )
	use openni2  || mycmakeargs+=( "-DCMAKE_DISABLE_FIND_PACKAGE_OpenNI2=TRUE" )
	use qt4      || mycmakeargs+=( "-DCMAKE_DISABLE_FIND_PACKAGE_Qt4=TRUE" )
	use qt5      && mycmakeargs+=( "-DRTABMAP_QT_VERSION=5" )
	cmake-utils_src_configure
}
