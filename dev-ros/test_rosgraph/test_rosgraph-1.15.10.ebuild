# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=test/${PN}

inherit ros-catkin

DESCRIPTION="Unit tests for rosgraph"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-ros/rosgraph[${PYTHON_SINGLE_USEDEP}] )
"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
