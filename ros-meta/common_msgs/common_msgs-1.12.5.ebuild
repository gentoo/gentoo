# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/common_msgs"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Messages that are widely used by other ROS packages"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/actionlib_msgs
	dev-ros/diagnostic_msgs
	dev-ros/geometry_msgs
	dev-ros/nav_msgs
	dev-ros/sensor_msgs
	dev-ros/shape_msgs
	dev-ros/stereo_msgs
	dev-ros/trajectory_msgs
	dev-ros/visualization_msgs
"
DEPEND="${RDEPEND}"
