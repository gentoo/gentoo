# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_plot"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="GUI plugin visualizing numeric values in a 2D plot"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	|| ( dev-python/matplotlib[${PYTHON_USEDEP}] dev-python/pyqwt:5[${PYTHON_USEDEP}] )
	dev-python/pyqtgraph[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-ros/qt_gui_py_common[${PYTHON_USEDEP}]
	dev-ros/rosgraph[${PYTHON_USEDEP}]
	dev-ros/rostopic[${PYTHON_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_USEDEP}]
	dev-ros/rqt_py_common[${PYTHON_USEDEP}]
	dev-ros/roslib[${PYTHON_USEDEP}]
	>=dev-ros/python_qt_binding-0.2.19[${PYTHON_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
