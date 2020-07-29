# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/common_tutorials"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs dev-ros/geometry_msgs"

inherit ros-catkin

DESCRIPTION="Demonstrates how to write an action server and client with the turtlesim"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/actionlib
	dev-ros/actionlib_msgs
	dev-ros/angles
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/turtlesim
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
