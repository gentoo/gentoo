# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/image_common"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="C++ interface for camera calibration information"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/camera_calibration_parsers
	dev-ros/image_transport
	dev-ros/roscpp
	dev-ros/roslib
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest dev-cpp/gtest )
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
