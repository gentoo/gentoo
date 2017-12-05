# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_srv"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="GUI plugin for introspecting available ROS message types"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosmsg[${PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_USEDEP}]
	dev-ros/rqt_msg[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
