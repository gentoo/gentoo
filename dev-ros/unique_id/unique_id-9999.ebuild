# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-geographic-info/unique_identifier"
VER_PREFIX=unique_identifier-
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="ROS Python and C++ interfaces for universally unique identifiers"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/uuid_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/roscpp
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest dev-python/nose[${PYTHON_USEDEP}] )"
