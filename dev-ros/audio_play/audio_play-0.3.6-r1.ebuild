# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-drivers/audio_common"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Outputs audio to a speaker from a source node"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-libs/boost:=
	media-libs/gstreamer:1.0
"
DEPEND="${RDEPEND}
	dev-ros/audio_common_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
RDEPEND="${RDEPEND}
	media-libs/gst-plugins-good:1.0
	media-libs/gst-plugins-base:1.0
"
BDEPEND="
	virtual/pkgconfig
"
