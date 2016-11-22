# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/ros_tutorials"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Demonstrates various features of ROS, as well as support packages which help demonstrate them"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp_tutorials
	dev-ros/rospy_tutorials
	dev-ros/turtlesim
"
DEPEND="${RDEPEND}"
