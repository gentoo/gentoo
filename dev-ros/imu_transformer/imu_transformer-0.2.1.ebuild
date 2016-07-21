# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/imu_pipeline"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Node/nodelet combination to transform sensor_msgs::Imu data from one frame into another"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/message_filters
	dev-ros/nodelet
	dev-ros/roscpp
	dev-ros/roslaunch
	dev-ros/tf2
	dev-ros/tf2_ros
	dev-ros/topic_tools
	dev-ros/tf2_sensor_msgs
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/tests.patch" )
