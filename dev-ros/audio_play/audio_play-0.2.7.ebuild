# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-drivers/audio_common"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Outputs audio to a speaker from a source node"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/audio_common_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/roscpp
	dev-libs/boost:=[threads]
	media-libs/gstreamer:0.10
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
RDEPEND="${RDEPEND}
	media-plugins/gst-plugins-alsa:0.10
	media-libs/gst-plugins-good:0.10
	media-libs/gst-plugins-base:0.10
"
