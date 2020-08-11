# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/ros_tutorials"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Attempts to show the features of ROS step-by-step"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-ros/roscpp_tutorials
	)"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
