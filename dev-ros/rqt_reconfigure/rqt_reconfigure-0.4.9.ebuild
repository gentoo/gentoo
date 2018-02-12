# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_reconfigure"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Provides the way to view and edit the parameters that are accessible via dynamic_reconfigure"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/dynamic_reconfigure[${PYTHON_USEDEP}]
	dev-ros/rospy[${PYTHON_USEDEP}]
	dev-ros/rqt_console[${PYTHON_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_USEDEP}]
	dev-ros/rqt_py_common[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
