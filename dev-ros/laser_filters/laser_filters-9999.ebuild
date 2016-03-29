# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/laser_filters"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Assorted filters designed to operate on 2D planar laser scanners"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-libs/boost:=
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf
	dev-cpp/eigen:3
	dev-ros/angles
	dev-ros/filters
	dev-ros/laser_geometry
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest[${PYTHON_USEDEP}] )"
