# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
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
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2
	dev-ros/tf2_ros
	dev-ros/tf2_sensor_msgs
"
DEPEND="${RDEPEND}"
