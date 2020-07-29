# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_plot"

inherit ros-catkin

DESCRIPTION="GUI plugin visualizing numeric values in a 2D plot"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep "dev-python/matplotlib[\${PYTHON_USEDEP}]")
	$(python_gen_cond_dep "dev-python/pyqtgraph[\${PYTHON_USEDEP}]")
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
	$(python_gen_cond_dep "dev-python/numpy[\${PYTHON_USEDEP}]")
	dev-ros/qt_gui_py_common[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosgraph[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rostopic[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_py_common[${PYTHON_SINGLE_USEDEP}]
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	>=dev-ros/python_qt_binding-0.2.19[${PYTHON_SINGLE_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
