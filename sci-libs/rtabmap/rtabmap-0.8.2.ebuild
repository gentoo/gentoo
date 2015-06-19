# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/rtabmap/rtabmap-0.8.2.ebuild,v 1.1 2015/01/19 10:04:03 aballier Exp $

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
IUSE="qt4 openni2"

RDEPEND="
	media-libs/opencv:=
	sci-libs/pcl[openni]
	sci-libs/vtk
	sys-libs/zlib
	openni2? ( dev-libs/OpenNI2 )
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtsvg:4
		dev-qt/qtcore:4
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	use openni2 || sed -e 's/OpenNI2)/DiSaBlEd)/' -i CMakeLists.txt || die
	use qt4     || sed -e 's/Qt4/DiSaBlEd/' -i CMakeLists.txt || die
	cmake-utils_src_configure
}
