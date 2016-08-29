# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-drivers/openni2_camera"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="ROS drivers for the Asus Xtion and Primesense Devices"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/image_transport
	dev-ros/camera_info_manager
	dev-ros/dynamic_reconfigure[${PYTHON_USEDEP}]
	dev-ros/nodelet
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/OpenNI2
"
DEPEND="${RDEPEND}"
