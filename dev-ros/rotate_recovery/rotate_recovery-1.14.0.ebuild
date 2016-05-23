# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	dev-ros/roscpp
	dev-ros/tf
	dev-ros/costmap_2d
	dev-ros/nav_core
	dev-ros/pluginlib
	dev-ros/base_local_planner
	dev-cpp/eigen:3
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules"
