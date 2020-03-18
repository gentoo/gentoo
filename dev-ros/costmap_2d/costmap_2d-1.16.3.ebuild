# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

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
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/pluginlib
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2
	dev-ros/tf2_ros
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/voxel_grid

	dev-ros/tf2_geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_sensor_msgs

	dev-cpp/eigen:3
	dev-libs/boost:=[threads]
	dev-libs/tinyxml2:=
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules
	test? (
		dev-ros/map_server
		dev-ros/rosbag
		dev-ros/rostest[${PYTHON_USEDEP}]
		dev-ros/rosunit
	)"
