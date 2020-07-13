# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros/geometry2"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Transform sensor_msgs with tf. Most notably, PointCloud2"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/tf2_ros[${PYTHON_USEDEP}]
	dev-ros/tf2
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-python/python_orocos_kdl[${PYTHON_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP},${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest[${PYTHON_USEDEP}] )
	dev-ros/cmake_modules"
