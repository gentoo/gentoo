# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/mavlink/mavros"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="MAVLink extendable communication node for ROS"
LICENSE="GPL-3 LGPL-3 BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/diagnostic_updater
	dev-ros/pluginlib
		dev-libs/tinyxml2:=
	dev-ros/roscpp
	dev-ros/tf
	dev-ros/angles
	dev-ros/libmavconn
	dev-ros/rosconsole_bridge
	dev-libs/boost:=
	dev-ros/eigen_conversions
	sci-geosciences/GeographicLib
	>=dev-ros/mavlink-gbp-release-2020.9.10
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
	>=dev-ros/mavros_msgs-${PV}[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
