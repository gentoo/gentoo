# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_logger_level"

inherit ros-catkin

DESCRIPTION="GUI plugin for configuring the logger level of ROS nodes"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
	dev-ros/rosnode[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosservice[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}"
