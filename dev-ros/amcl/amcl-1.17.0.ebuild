# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Probabilistic localization system for a robot moving in 2D"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/diagnostic_updater[${PYTHON_USEDEP}]
	dev-ros/dynamic_reconfigure[${PYTHON_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/message_filters
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/rosbag
		dev-libs/boost:=
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2
	dev-ros/tf2_geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_ros
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest[${PYTHON_USEDEP}] dev-python/python_orocos_kdl[${PYTHON_USEDEP}] dev-ros/map_server[${PYTHON_USEDEP}] )
"
PATCHES=( "${FILESDIR}/cmake.patch" )
