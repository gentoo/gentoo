# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/geometry"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Maintains the relationship between coordinate frames in a tree structure buffered in time"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=[threads]
	dev-ros/angles
	dev-ros/message_filters
	dev-ros/rosconsole
	dev-ros/rostime
	dev-ros/roscpp
	dev-ros/tf2_ros
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/rostest[${PYTHON_USEDEP}]
		dev-cpp/gtest
		dev-python/nose[${PYTHON_USEDEP}]
	)"
PATCHES=( "${FILESDIR}/gcc6.patch" )
