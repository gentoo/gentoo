# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/pcl_conversions"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Provides conversions from PCL data types and ROS message types"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	sci-libs/pcl:=
	dev-ros/pcl_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-cpp/eigen:3
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
