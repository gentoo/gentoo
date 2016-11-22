# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/diagnostics"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="diagnostic_aggregator tests"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/diagnostic_aggregator
	dev-ros/diagnostic_msgs
	dev-ros/pluginlib
	dev-ros/roscpp
	dev-ros/rospy
	dev-ros/rostest
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/gcc6.patch" )
