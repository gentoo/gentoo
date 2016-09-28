# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
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
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/boost:=
"
DEPEND="${RDEPEND} test? ( dev-ros/rostest )"
