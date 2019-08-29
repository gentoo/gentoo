# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-visualization/visualization_tutorials"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Interactive marker tutorials"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/interactive_markers
	dev-ros/visualization_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/tf[${PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
