# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-simulation/gazebo_ros_pkgs"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
CATKIN_HAS_MESSAGES=yes
ROS_SUBDIR=${PN}
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/geometry_msgs dev-ros/sensor_msgs dev-ros/trajectory_msgs dev-ros/std_msgs dev-ros/std_srvs"

inherit ros-catkin

DESCRIPTION="Message and service data structures for interacting with Gazebo from ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
