# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros-simulation/stage_ros"
KEYWORDS="~amd64"

inherit ros-catkin

DESCRIPTION="ROS specific hooks and tools for the Stage simulator"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-ros/geometry_msgs
	dev-ros/nav_msgs
	dev-ros/roscpp
	dev-ros/rostest
	dev-ros/sensor_msgs
	dev-ros/std_msgs
	dev-ros/tf
	x11-libs/fltk
	>=sci-electronics/Stage-4.3:=
"
DEPEND="${RDEPEND}
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? ( dev-ros/rostest )
"
BDEPEND="
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/tests.patch" )
