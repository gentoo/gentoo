# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs dev-ros/geometry_msgs dev-ros/nav_msgs"
CATKIN_HAS_MESSAGES=yes
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Fast interpolated navigation function that can be used to create plans for a mobile base"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/costmap_2d
	dev-ros/nav_core
	dev-ros/pcl_conversions
	dev-ros/pcl_ros
	dev-ros/pluginlib
	dev-ros/roscpp
	dev-ros/tf
	dev-ros/visualization_msgs
	dev-cpp/eigen:3
	sci-libs/pcl
	x11-libs/fltk
	media-libs/netpbm
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
	dev-ros/cmake_modules"

PATCHES=( "${FILESDIR}/pgm_h_location.patch" )
