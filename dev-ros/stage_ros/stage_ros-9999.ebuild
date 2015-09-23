# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros-simulation/stage_ros"
KEYWORDS="~amd64"

inherit ros-catkin

DESCRIPTION="ROS specific hooks and tools for the Stage simulator"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=[threads]
	dev-ros/geometry_msgs
	dev-ros/nav_msgs
	dev-ros/roscpp
	dev-ros/rostest
	dev-ros/sensor_msgs
	dev-ros/std_msgs
	dev-ros/tf
	x11-libs/fltk
	sci-electronics/Stage
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest )
	virtual/pkgconfig"
PATCHES=( "${FILESDIR}/stageconfig.patch" "${FILESDIR}/fltk.patch" )
