# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/mavlink/mavros"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="MAVLink extendable communication node for ROS"
LICENSE="GPL-3 LGPL-3 BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/diagnostic_updater
	dev-ros/pluginlib
	dev-ros/roscpp
	dev-ros/tf
	dev-ros/angles
	dev-ros/libmavconn
	dev-ros/rosconsole_bridge
	dev-libs/boost:=
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/mavros_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}"
