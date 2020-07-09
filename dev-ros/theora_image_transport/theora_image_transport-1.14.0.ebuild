# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/image_transport_plugins"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Plugin for transparently sending an image stream encoded with the Theora codec"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge
	media-libs/opencv:=
	dev-ros/dynamic_reconfigure
	dev-ros/image_transport
	media-libs/opencv
	dev-ros/rosbag
	dev-ros/pluginlib
	media-libs/libogg
	media-libs/libtheora[encode]
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig"
