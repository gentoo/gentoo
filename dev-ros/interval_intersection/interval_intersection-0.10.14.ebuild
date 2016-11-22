# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/calibration"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/actionlib_msgs dev-ros/geometry_msgs dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Tools for calculating the intersection of interval messages coming in on several topics"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=[threads]
	dev-ros/actionlib
	dev-ros/calibration_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/roscpp_serialization
	dev-ros/rostime
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
PATCHES=( "${FILESDIR}/gcc6.patch" )
