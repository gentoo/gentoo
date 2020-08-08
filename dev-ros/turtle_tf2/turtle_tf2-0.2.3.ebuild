# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/geometry_tutorials"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Demonstrates how to write a tf2 broadcaster and listener with the turtlesim"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/roscpp
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/tf2
	dev-ros/tf2_ros[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf2_geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/turtlesim[${PYTHON_SINGLE_USEDEP}]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
