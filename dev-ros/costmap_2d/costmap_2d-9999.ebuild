# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"
CATKIN_HAS_MESSAGES=yes
PYTHON_COMPAT=( python2_7 )
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs dev-ros/geometry_msgs dev-ros/map_msgs"

inherit ros-catkin

DESCRIPTION="Creates a 2D costmap from sensor data"
LICENSE="BSD"
SLOT="0"
IUSE=""
REQUIRED_USE="ros_messages_cxx"

RDEPEND="
	dev-ros/dynamic_reconfigure[${PYTHON_USEDEP}]
	dev-ros/laser_geometry
	dev-ros/message_filters
	dev-ros/nav_msgs
	dev-ros/pcl_conversions
	dev-ros/pcl_ros
	dev-ros/pluginlib
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf
	dev-ros/voxel_grid
	dev-cpp/eigen:3
	sci-libs/pcl
	dev-libs/boost:=[threads]
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules
	test? ( dev-ros/rostest[${PYTHON_USEDEP}] )"
