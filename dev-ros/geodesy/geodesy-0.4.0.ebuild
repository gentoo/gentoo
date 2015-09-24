# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-geographic-info/geographic_info"
VER_PREFIX=geographic_info-
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Python and C++ interfaces for manipulating geodetic coordinates"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/angles
	dev-ros/geographic_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf
	dev-ros/unique_id
	dev-ros/uuid_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-python/pyproj[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/rosunit[${PYTHON_USEDEP}]
		dev-cpp/gtest
		dev-python/nose[${PYTHON_USEDEP}]
	)"
