# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Dynamic Window Approach to local robot navigation on a plane"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/angles:0
	dev-ros/base_local_planner
	dev-ros/costmap_2d
	dev-ros/dynamic_reconfigure[${PYTHON_SINGLE_USEDEP}]
	dev-cpp/eigen:3
	dev-ros/nav_core
	dev-ros/pluginlib
	dev-ros/roscpp

	dev-ros/tf2
	dev-ros/tf2_ros

	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
