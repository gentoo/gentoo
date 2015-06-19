# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/console_bridge/console_bridge-0.2.7.ebuild,v 1.1 2015/04/14 12:09:50 aballier Exp $

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros/console_bridge"
fi

inherit ${SCM} cmake-utils multilib

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://github.com/ros/console_bridge/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="A ROS-independent package for logging into rosconsole/rosout for ROS-dependent packages."
HOMEPAGE="http://wiki.ros.org/console_bridge"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/boost:=[threads]"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "s/DESTINATION lib/DESTINATION $(get_libdir)/" CMakeLists.txt || die
	cmake-utils_src_prepare
}
