# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Move slow and clear"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-ros/costmap_2d-1.16
	dev-ros/nav_core
	dev-ros/pluginlib
	dev-ros/roscpp

	dev-libs/boost:=
	dev-cpp/eigen:3
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
