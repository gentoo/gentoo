# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/laser_geometry"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Class for converting from a 2D laser scan into a point cloud"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-libs/boost:=[threads]
	dev-ros/tf
	dev-ros/tf2_ros[${PYTHON_USEDEP}]
	dev-cpp/eigen:3
	dev-ros/angles
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
