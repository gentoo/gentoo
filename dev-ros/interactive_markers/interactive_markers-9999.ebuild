# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros-visualization/interactive_markers"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="3D interactive marker communication library for RViz and similar tools"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/tf
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/roscpp
	dev-ros/rosconsole
	dev-ros/rostest[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
