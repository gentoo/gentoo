# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-planning/navigation"
CATKIN_HAS_MESSAGES=yes
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Trajectory Rollout and Dynamic Window approaches to local robot navigation on a plane"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/tf
	dev-ros/dynamic_reconfigure[${PYTHON_USEDEP}]
	dev-ros/nav_core
	dev-ros/pcl_conversions
	dev-ros/rostest
	dev-ros/costmap_2d
	dev-ros/pluginlib
	dev-ros/angles
	dev-libs/boost:=[threads]
	dev-cpp/eigen:3
	sci-libs/pcl
"
DEPEND="${RDEPEND}
	dev-ros/cmake_modules
	test? ( dev-cpp/gtest )
"
