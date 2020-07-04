# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Path planner library and node"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-ros/costmap_2d-1.16
	dev-ros/dynamic_reconfigure[${PYTHON_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/nav_core
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/navfn
	dev-ros/pluginlib
	dev-ros/roscpp
	dev-ros/tf2_ros

	dev-libs/boost:=
	dev-libs/console_bridge:=

	dev-ros/angles
	dev-ros/tf2_geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}"
