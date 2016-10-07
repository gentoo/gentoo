# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/image_transport_plugins"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
PYTHON_COMPAT=( python2_7 )
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Plugin to image_transport for transparently sending an image stream encoded with the Theora codec"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge
	dev-ros/dynamic_reconfigure
	dev-ros/image_transport
	media-libs/opencv
	dev-ros/rosbag
	dev-ros/pluginlib
	media-libs/libogg
	media-libs/libtheora[encode]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
