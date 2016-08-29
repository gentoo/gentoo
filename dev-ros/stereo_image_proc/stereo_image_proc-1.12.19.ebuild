# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/image_pipeline"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Stereo and single image rectification and disparity processing"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge
	dev-ros/dynamic_reconfigure
	dev-ros/image_geometry
	dev-ros/image_proc
	dev-ros/image_transport
	dev-ros/message_filters
	dev-ros/nodelet
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/stereo_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	media-libs/opencv
"
DEPEND="${RDEPEND}"
