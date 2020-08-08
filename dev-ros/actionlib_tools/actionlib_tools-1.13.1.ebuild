# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CATKIN_HAS_MESSAGES=yes
ROS_REPO_URI="https://github.com/ros/actionlib"
KEYWORDS="~amd64 ~arm"
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/actionlib_msgs dev-ros/std_msgs"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Tools for dealing with actionlib"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
RDEPEND="${RDEPEND}
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rostopic[${PYTHON_SINGLE_USEDEP}]
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/actionlib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/actionlib_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
