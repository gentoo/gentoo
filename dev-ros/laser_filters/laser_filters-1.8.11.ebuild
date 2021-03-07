# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/laser_filters"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Assorted filters designed to operate on 2D planar laser scanners"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/tf
	dev-ros/filters
	dev-ros/message_filters
	dev-ros/laser_geometry
	dev-ros/pluginlib
	dev-ros/angles
	dev-ros/dynamic_reconfigure

	dev-libs/tinyxml2:=
	dev-libs/console_bridge:=
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-cpp/gtest
	)"
PATCHES=( "${FILESDIR}/eigen.patch" )
