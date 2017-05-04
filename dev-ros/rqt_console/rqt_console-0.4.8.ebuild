# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_console"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="GUI plugin for displaying and filtering ROS messages"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/rospkg[${PYTHON_USEDEP}]
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_USEDEP}]
	dev-ros/rqt_logger_level[${PYTHON_USEDEP}]
	>=dev-ros/python_qt_binding-0.2.19[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
