# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/image_pipeline"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Simple viewer for ROS image topics"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=[threads]
	media-libs/opencv
	x11-libs/gtk+:2
	dev-ros/camera_calibration_parsers
	dev-ros/cv_bridge
	dev-ros/image_transport
	dev-ros/message_filters
	dev-ros/nodelet
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/stereo_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
DEPEND="${RDEPEND}"
