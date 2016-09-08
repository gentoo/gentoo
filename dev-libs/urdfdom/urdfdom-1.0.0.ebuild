# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros/urdfdom"
fi

inherit ${SCM} cmake-utils

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://github.com/ros/urdfdom/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="URDF (U-Robot Description Format) library"
HOMEPAGE="http://ros.org/wiki/urdf"
LICENSE="BSD"
SLOT="0/1"
IUSE=""

RDEPEND=">=dev-libs/urdfdom_headers-1.0.0
	>=dev-libs/console_bridge-0.3
	dev-libs/tinyxml
	dev-libs/boost:=[threads]"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's/set(CMAKE_INSTALL_LIBDIR/#/' CMakeLists.txt || die
	cmake-utils_src_prepare
}
