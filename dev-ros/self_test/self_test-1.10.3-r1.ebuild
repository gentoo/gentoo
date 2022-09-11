# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/diagnostics"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Robot self-test node"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/diagnostic_updater
	dev-ros/roscpp
	dev-ros/rostest
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? ( dev-ros/rostest )"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
