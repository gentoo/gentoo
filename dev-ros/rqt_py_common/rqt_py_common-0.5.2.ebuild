# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt"
ROS_SUBDIR=${PN}
# Tests have messages
CATKIN_HAS_MESSAGES=yes

inherit ros-catkin

DESCRIPTION="Common functionality for rqt plugins written in Python"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/qt_gui[${PYTHON_SINGLE_USEDEP}]
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rostopic[${PYTHON_SINGLE_USEDEP}]
	>=dev-ros/python_qt_binding-0.2.19[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/std_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	)
"
