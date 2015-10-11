# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/geometry_tutorials"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Demonstrates how to write a tf broadcaster and listener with the turtlesim"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/geometry_msgs[${PYTHON_USEDEP}]
	dev-ros/roscpp
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/std_msgs[${PYTHON_USEDEP}]
	dev-ros/tf[${PYTHON_USEDEP}]
	dev-ros/turtlesim[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
