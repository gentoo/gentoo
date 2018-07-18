# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/depthimage_to_laserscan"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Converts a depth image to a laser scan for use with navigation and localization"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	media-libs/opencv:=
	dev-ros/dynamic_reconfigure[${PYTHON_USEDEP}]
	dev-ros/image_geometry
	dev-ros/image_transport
	dev-ros/nodelet
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/isnan.patch" "${FILESDIR}/pluginlib.patch" )
