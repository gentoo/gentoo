# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}

inherit ros-catkin

DESCRIPTION="Command-line tools for displaying information about message and services"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/genmsg[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosbag[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/test_rosmaster[${PYTHON_SINGLE_USEDEP}]
		dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
		dev-ros/std_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
		dev-ros/std_srvs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	)
"

src_test() {
	export ROS_PACKAGE_PATH="${S}/../..:${EPREFIX}/usr/share/ros_packages/diagnostic_msgs:${EPREFIX}/usr/share/ros_packages/std_msgs:${EPREFIX}/usr/share/ros_packages/std_srvs"
	ros-catkin_src_test
}
