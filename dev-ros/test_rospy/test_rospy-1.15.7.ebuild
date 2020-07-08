# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=test/${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs dev-ros/test_rosmaster"

PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Unit tests for rospy"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-ros/rostest[${PYTHON_USEDEP}]
	dev-ros/std_msgs[${PYTHON_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/test_rosmaster[${PYTHON_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rosunit[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-ros/rosbuild
		dev-ros/rosgraph[${PYTHON_USEDEP}]
		dev-ros/rospy[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"
