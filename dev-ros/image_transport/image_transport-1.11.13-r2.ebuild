# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/image_common"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Transparent support for transporting images in low-bandwidth compressed formats"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/message_filters
	dev-ros/pluginlib
		dev-libs/tinyxml2:=
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/roslib
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/boost:=
	dev-libs/console_bridge:=
	dev-ros/class_loader:=
"
DEPEND="${RDEPEND}"
