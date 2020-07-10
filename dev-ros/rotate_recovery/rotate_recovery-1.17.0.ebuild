# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Recovery behavior that attempts to clear space by performing a 360 degree rotation of the robot"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/angles
	dev-ros/base_local_planner
	dev-ros/costmap_2d
	dev-cpp/eigen:3
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	>=dev-ros/nav_core-1.16
	dev-ros/pluginlib
	dev-ros/roscpp
	dev-ros/tf2
	dev-ros/tf2_geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_ros

	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules"
