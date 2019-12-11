# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Recovery behavior that attempts to clear space by reverting the costmaps to the static map"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-ros/costmap_2d-1.16.3
	dev-cpp/eigen:3
	dev-ros/nav_core
	dev-ros/pluginlib
	dev-ros/roscpp
	dev-ros/tf2_ros

	dev-libs/boost:=[threads]
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules
	test? ( dev-ros/rostest dev-cpp/gtest )
"
