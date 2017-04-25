# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_launch"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Easy view of .launch files"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rqt_py_common[${PYTHON_USEDEP}]
	dev-ros/roslaunch[${PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/rqt_console[${PYTHON_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_USEDEP}]
	dev-ros/rqt_py_common[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
