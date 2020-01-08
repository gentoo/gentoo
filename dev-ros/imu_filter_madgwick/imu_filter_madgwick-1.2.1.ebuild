# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ccny-ros-pkg/imu_tools"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Fuses angular velocities, accelerations, and (optionally) magnetic readings from an IMU device"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2
	dev-ros/tf2_geometry_msgs
	dev-ros/tf2_ros
	dev-ros/nodelet
	dev-libs/console_bridge:=
	dev-ros/pluginlib
	dev-ros/message_filters
	dev-ros/dynamic_reconfigure
	dev-libs/boost:=[threads]
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rosunit )
"
PATCHES=( "${FILESDIR}/boost_signals.patch" )
