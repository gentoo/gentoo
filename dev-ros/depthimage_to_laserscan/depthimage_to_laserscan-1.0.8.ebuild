# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/depthimage_to_laserscan"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Converts a depth image to a laser scan for use with navigation and localization"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/dynamic_reconfigure[${PYTHON_SINGLE_USEDEP}]
	dev-ros/image_geometry
	dev-ros/image_transport
	dev-ros/nodelet
	dev-ros/roscpp

	media-libs/opencv:=
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-cpp/gtest
	)
"
PATCHES=( "${FILESDIR}/isnan.patch" )
