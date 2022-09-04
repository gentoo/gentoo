# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-drivers/openni2_camera"
CATKIN_HAS_MESSAGES=yes
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="ROS drivers for the Asus Xtion and Primesense Devices"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/image_transport
	dev-ros/camera_info_manager
	dev-ros/dynamic_reconfigure[${PYTHON_SINGLE_USEDEP}]
	dev-ros/nodelet
	dev-libs/console_bridge:=
	dev-ros/roscpp
	dev-libs/OpenNI2
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
