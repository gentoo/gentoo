# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros/console_bridge"
fi

inherit ${SCM} cmake

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://github.com/ros/console_bridge/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="A ROS-independent package for logging into rosconsole/rosout"
HOMEPAGE="http://wiki.ros.org/console_bridge"
LICENSE="BSD"
SLOT="0/1"
IUSE="test"

RDEPEND="dev-libs/boost:=[threads]"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		net-misc/wget
		dev-util/cppcheck
	)
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
	)
	cmake_src_configure
}

src_test() {
	export AMENT_CPPCHECK_ALLOW_1_88=yes
	cmake_src_test
}
