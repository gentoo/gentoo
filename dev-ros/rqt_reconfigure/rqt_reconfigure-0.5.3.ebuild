# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_reconfigure"

inherit ros-catkin

DESCRIPTION="Provides the way to view and edit the parameters from dynamic_reconfigure"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/dynamic_reconfigure[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_console[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_py_common[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/roslint[${PYTHON_SINGLE_USEDEP}]
	)
"
