# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_action"

inherit ros-catkin

DESCRIPTION="Introspect all available ROS action (from actionlib) types"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_msg[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_py_common[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}"
