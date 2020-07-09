# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ccny-ros-pkg/imu_tools"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Fuses angular velocities, accelerations, and magnetic readings from an IMU"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/message_filters
	dev-ros/roscpp
	dev-ros/tf
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
BDEPEND="
	dev-ros/cmake_modules
"
