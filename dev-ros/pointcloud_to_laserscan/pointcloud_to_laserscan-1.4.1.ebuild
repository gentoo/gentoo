# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/pointcloud_to_laserscan"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Converts a 3D Point Cloud into a 2D laser scan"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/message_filters
	dev-ros/nodelet
	dev-ros/roscpp
	dev-ros/tf2
	dev-ros/tf2_ros
	dev-ros/tf2_sensor_msgs
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
