# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
CATKIN_HAS_MESSAGES=yes
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Trajectory Rollout and Dynamic Window approaches to local robot navigation on a plane"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/angles
	>=dev-ros/costmap_2d-1.16
	dev-ros/dynamic_reconfigure[${PYTHON_USEDEP}]
	dev-cpp/eigen:3
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	>=dev-ros/nav_core-1.16
	dev-ros/pluginlib
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2
	dev-ros/tf2_geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_ros
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/voxel_grid
	dev-libs/boost:=[threads]
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules
	test? ( dev-cpp/gtest dev-ros/rosunit[${PYTHON_USEDEP}] )
"
