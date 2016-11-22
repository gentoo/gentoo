# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=test/${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/rosgraph_msgs dev-ros/std_msgs"

PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Unit tests for roslib"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	test? (	dev-ros/roslib[${PYTHON_USEDEP}] dev-python/nose[${PYTHON_USEDEP}] dev-ros/test_rosmaster )
"
