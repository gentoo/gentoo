# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/robot_model"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="C++ parser for the Unified Robot Description Format (URDF)"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=[threads]
	dev-libs/urdfdom
	dev-libs/urdfdom_headers
	dev-ros/urdf_parser_plugin
	dev-ros/pluginlib
	dev-ros/rosconsole_bridge
	dev-ros/roscpp
	dev-libs/tinyxml
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules
	test? ( dev-ros/rostest[${PYTHON_USEDEP}] dev-cpp/gtest )"
