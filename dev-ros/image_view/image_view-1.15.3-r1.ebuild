# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/image_pipeline"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Simple viewer for ROS image topics"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/camera_calibration_parsers
	>=dev-ros/cv_bridge-1.11.10
	dev-ros/image_transport
	dev-ros/message_filters
	dev-ros/nodelet
	dev-ros/rosconsole
	dev-libs/console_bridge:=
	dev-ros/roscpp
	dev-ros/dynamic_reconfigure[${PYTHON_SINGLE_USEDEP}]

	dev-libs/boost:=
	media-libs/opencv:=
	x11-libs/gtk+:3
	media-libs/harfbuzz:=
"
DEPEND="${RDEPEND}
	dev-ros/stereo_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
BDEPEND="
	virtual/pkgconfig
"
