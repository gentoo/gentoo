# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_moveit"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Assists monitoring tasks for MoveIt! motion planner"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosnode[${PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/rostopic[${PYTHON_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_USEDEP}]
	dev-ros/rqt_topic[${PYTHON_USEDEP}]
	dev-ros/sensor_msgs[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
