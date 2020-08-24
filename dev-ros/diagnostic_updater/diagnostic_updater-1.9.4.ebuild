# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/diagnostics"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Tools for updating diagnostics"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/roscpp
	dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
	dev-ros/std_msgs[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? ( dev-cpp/gtest dev-ros/rostest[${PYTHON_SINGLE_USEDEP}] )"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
