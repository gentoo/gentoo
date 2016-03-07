# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/geometry_experimental"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="TF2 unit tests"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/rostest[${PYTHON_USEDEP}]
	dev-ros/tf
	dev-ros/tf2
	dev-ros/tf2_bullet
	dev-ros/tf2_ros[${PYTHON_USEDEP}]
	dev-ros/tf2_geometry_msgs[${PYTHON_USEDEP}]
	dev-ros/tf2_kdl[${PYTHON_USEDEP}]
	dev-ros/tf2_msgs
	sci-libs/orocos_kdl
	dev-python/python_orocos_kdl[${PYTHON_USEDEP}]
	dev-libs/boost:=[threads]
	dev-cpp/gtest"

mycatkincmakeargs=( "-DCATKIN_ENABLE_TESTING=ON" )
