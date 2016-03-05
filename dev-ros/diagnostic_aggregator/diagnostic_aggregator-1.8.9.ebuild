# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/diagnostics"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Aggregates ROS diagnostics"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/pluginlib
	dev-ros/roscpp
	dev-ros/rospy
	dev-ros/rostest
	dev-ros/xmlrpcpp
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	test? ( dev-ros/rostest )"
