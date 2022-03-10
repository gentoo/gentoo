# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/image_pipeline"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Nodelets for processing depth images such as those produced by OpenNI camera"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge
	media-libs/opencv:=
	dev-ros/eigen_conversions
	dev-ros/image_geometry
	dev-ros/image_transport
	dev-ros/message_filters
	dev-ros/nodelet
	dev-ros/tf2
	dev-ros/tf2_ros
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/stereo_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
