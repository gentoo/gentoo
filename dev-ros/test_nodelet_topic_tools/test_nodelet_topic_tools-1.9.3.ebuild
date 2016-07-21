# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/nodelet_core"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Nodelet topic tools unit tests"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/message_filters
	dev-ros/nodelet
	dev-ros/nodelet_topic_tools
	dev-ros/pluginlib
	dev-ros/roscpp
	dev-ros/rostest
"
DEPEND="${RDEPEND}"
