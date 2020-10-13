# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_robot_monitor"

inherit ros-catkin

DESCRIPTION="Displays messages that are published by diagnostic_aggregator"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/diagnostic_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/python_qt_binding[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
	dev-ros/qt_gui[${PYTHON_SINGLE_USEDEP}]
	dev-ros/qt_gui_py_common[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_py_common[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_bag[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}"
