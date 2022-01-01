# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Attempts to find a legal place to put a carrot for the robot to follow"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/base_local_planner
	dev-ros/costmap_2d
	dev-cpp/eigen:3
	dev-ros/nav_core
	dev-ros/pluginlib
	dev-ros/roscpp
	dev-ros/tf2
	dev-ros/tf2_ros

	dev-libs/console_bridge:=
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/tf2_geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
