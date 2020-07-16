# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_shell"

inherit ros-catkin

DESCRIPTION="GUI plugin providing an interactive shell"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/rospkg[${PYTHON_USEDEP}]
	dev-ros/qt_gui[${PYTHON_USEDEP}]
	dev-ros/qt_gui_py_common[${PYTHON_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
