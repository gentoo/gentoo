# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-drivers/audio_common"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
PYTHON_COMPAT=( python2_7 )
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/actionlib_msgs"

inherit ros-catkin

DESCRIPTION="ROS node that translates commands on a ROS topic (robotsound) into sounds"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/roslib
	media-libs/gstreamer:1.0
	dev-ros/audio_common_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
RDEPEND="${RDEPEND}
	dev-python/gst-python[${PYTHON_USEDEP}]
	app-accessibility/festival
	media-libs/gst-plugins-good:1.0
	media-libs/gst-plugins-base:1.0
"
