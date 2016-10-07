# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/tu-darmstadt-ros-pkg/hector_localization"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Extended Kalman Filter (EKF) that estimates the 6DOF pose of the robot"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rostime
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geographic_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3"
PATCHES=( "${FILESDIR}/includes.patch" )
