# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/tu-darmstadt-ros-pkg/hector_localization"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="hector_pose_estimation node and the hector_pose_estimation nodelet"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/hector_pose_estimation_core
	dev-ros/nodelet
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf
	dev-ros/message_filters
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
# dev-ros/hector_timing
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.3.0-pluginlib.patch )
